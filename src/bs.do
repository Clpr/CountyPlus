/*******************************************************************************
TABLE: HOUSEHOLD BALANCE SHEET
*******************************************************************************/

version 15

clear
cls

* PARAM: AVG HOUSING UNITS PER HOUSE
global AVGHUPH = 1.8


* ASSET: EQUITY (S) & BOND (B) -------------------------------------------------
{
	use "output/id.dta", clear
	keep year fips
	
	* merge: flow of funds, agg holdings
	merge m:1 year using "data/Fed Flow of Funds - Balance Sheet of Household and Nonprofit Organizations 1952-2021/ffof_hhnpo.dta"
	keep if _merge != 2 // left join
	drop _merge
	
	* merge: SOI
	merge 1:1 fips year using "data/Survey of Income/soi.dta"
	keep if _merge != 2
	drop _merge fips_state fips_county
	
	* na & outliers
	foreach var in agi sws div int {
		gen int _sid = floor(fips / 1000)
		* outliers: SOI, x-sectional
		bysort year _sid: egen _avg = mean(soi_`var')
		replace soi_`var' = _avg if soi_`var' < 0
		drop _sid _avg
		* interpolation: SOI, county time series
		bysort fips: mipolate soi_`var' year, linear e gen(_tmp)
		replace soi_`var' = _tmp if missing(soi_`var')
		drop _tmp
	}
	
	* make: shares/distribution
	bysort year: egen _aggs = sum(soi_div)
	bysort year: egen _aggb = sum(soi_int)
	gen _shre = soi_div / _aggs
	gen _shrb = soi_int / _aggb
	drop _aggs _aggb
	
	
	* make: equity & fixed-income holding (millions of dollars)
	gen nw_s = (ffof_directequity + ffof_indireequity) * _shre
	gen nw_b = (ffof_directdebtsecu + ffof_indiredebtsecu) * _shrb
	
	* check missings & feasibility
	mdesc
	su
	
	* slim
	drop ffof_* soi_* _shre _shrb
	
	* save
	save "output/_nw_sb.dta", replace
}

* LIABILITIES: DEBT (D) --------------------------------------------------------
{
	use "output/id.dta", clear
	keep year fips
	
	* merge: SOI
	merge 1:1 fips year using "data/Survey of Income/soi.dta"
	keep if _merge != 2
	drop _merge fips_state fips_county
	
	* na & outliers
	foreach var in agi sws div int {
		gen int _sid = floor(fips / 1000)
		* outliers: SOI, x-sectional
		bysort year _sid: egen _avg = mean(soi_`var')
		replace soi_`var' = _avg if soi_`var' < 0
		drop _sid _avg
		* interpolation: SOI, county time series
		bysort fips: mipolate soi_`var' year, linear e gen(_tmp)
		replace soi_`var' = _tmp if missing(soi_`var')
		drop _tmp
	}
	
	* merge: ffof EFA debt-to-income ratio
	merge 1:1 fips year using "data/Fed Flow of Funds - EFA - Household Debt/d2y.dta"
	keep if _merge != 2
	drop _merge
	
	* na & outliers
	foreach var of varlist ffof_* {
		* na, longitudinal interpolation
		bysort year: mipolate `var' year, linear e gen(_tmp)
		replace `var' = _tmp if missing(`var')
		drop _tmp
		* outliers, set 0 (Boise County, IH, 16015)
		replace `var' = 0 if `var' < 0
	}
	
	* make: debt (million dollar)
	gen nw_d = ffof_efa_d2y * soi_agi / (1E+3)
	
	* slim
	keep fips year ffof_efa_d2y nw_d
	
	* check missings & feasibility
	mdesc
	su
	
	save "output/_nw_d.dta", replace
}


* ASSET: HOUSING (H) -----------------------------------------------------------
{	
	use "output/id.dta", clear
	keep year fips
	
	* merge: housing price
	merge 1:1 fips year using "data/Federal Housing Finance Agency/hpi.dta"
	keep if _merge != 2
	drop _merge
	drop fips_state fips_county
	
	* flag: if HPI available (but not interpolated)
	gen flag_nointerp_hpi = !missing(hpi)
	
	* interpolation: longitudinally for occasional missings
	bysort fips: mipolate hpi year, linear e gen(_tmp)
	replace hpi = _tmp if missing(hpi) & (!missing(_tmp))
	drop _tmp
	* special cases: linear extrapolation --> negative price, use backward const
	replace hpi = . if hpi < 0
	bysort fips: mipolate hpi year, backward e gen(_tmp)
	replace hpi = _tmp if missing(hpi) & (!missing(_tmp))
	drop _tmp

	* interpolation: x-sectionally for whole-county missings
	bysort year: egen _tmp = mean(hpi)
	replace hpi = _tmp if missing(hpi)
	drop _tmp

	* fill: 2019 HPI
	bysort fips: gen _tmp = hpi if year == 2019
	bysort fips: egen _hpi19 = mean(_tmp)
	drop _tmp
	
	* merge: estimated ACS 2019 median housing value (dollars)
	merge m:1 fips using "data/American Community Survey/mhv19.dta"
	keep if _merge != 2
	drop _merge
	drop fips_state fips_county
	drop mhv19_5y mhv19_1y
	
	* merge: total housing units
	merge 1:1 fips year using "data/National State and County Housing Unit Totals/thu.dta"
	keep if _merge != 2
	drop _merge
	
	* interpolation: x-sectionally for Valdez-Cordova Census, Alaska (02261)
	bysort year: egen _tmp = mean(cb_huest)
	replace cb_huest = _tmp if missing(cb_huest)
	drop _tmp
	
	* make: housing wealth holding (million dollars)
	gen nw_h = cb_huest / ${AVGHUPH} * mhv19 * hpi / _hpi19 / (1E+6)
	
	* gc
	drop _hpi19
	
	* labelling
	la var flag_nointerp_hpi "Flag: Original HPI records without interpolation"
	
	* check missings & feasibility
	mdesc
	su
	
	save "output/_nw_h.dta", replace
}




* MERGE ------------------------------------------------------------------------
{
	use "output/_nw_sb.dta", clear
	merge 1:1 fips year using "output/_nw_h.dta", nogenerate
	merge 1:1 fips year using "output/_nw_d.dta", nogenerate
	
	* make: net worth
	gen nw = nw_s + nw_b + nw_h - nw_d
	
	* labelling
	la var nw   "Net worth, million USD"
	la var nw_s "Net worth: Equity holding, million USD"
	la var nw_b "Net worth: Bond holding, million USD"
	la var nw_h "Net worth: Housing holding, million USD"
	la var nw_d "Net worth: Debt holding, million USD"
	
	* check missings & feasibility
	mdesc
	su

	* gc
	capture : erase "output/_nw_sb.dta"
	capture : erase "output/_nw_d.dta"
	capture : erase "output/_nw_h.dta"
	
	order *, alphabetic
	order fips year
	
	save "output/bs.dta", replace

}


* FINE TUNING: LEVERAGE RATIO  -------------------------------------------------
{
	use "output/bs.dta", clear
	* merge with population
	merge 1:1 fips year using "data/Vintage Population Estimates for Demographics/output/vpe.dta"
	keep if _merge != 2
	drop _merge
	* agg
	foreach v in s b h {
		bysort year: egen `v' = sum(nw_`v')
	}
	bysort year: egen NW = sum(nw)
	keep year s b h NW
	duplicates drop
	sort year
	
	* merge with flow of funds
	merge m:1 year using "data/Fed Flow of Funds - Balance Sheet of Household and Nonprofit Organizations 1952-2021/ffof_hhnpo.dta"
	keep if _merge != 2 // left join
	drop _merge
	
	* leverage: CountyPlus
	gen h2a = h/(s+b) * 100
	* leverage: Flow of Funds
	gen h2a_ffof = ffof_realestate / (ffof_directequity + ffof_indireequity + ffof_directdebtsecu + ffof_indiredebtsecu) * 100
	
	la var h2a "H / (S+B), CountyPlus"
	la var h2a_ffof "Real estate / (Equity + Debt securities), Flow of Funds"
	
	* visualization
	set scheme s1mono
	tw (line h2a year) (line h2a_ffof year, lpattern(dash)) ///
		, xtitle("Year") ytitle("Percent") legend(rows(2)) ///
		nodraw name(fig1, replace)
	graph save "output/fig_finetuning.gph", replace
}
