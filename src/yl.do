/*******************************************************************************
TABLE: INCOME, EMPLOYMENT, POVERTY AND LABOR MARKET
*******************************************************************************/
version 15
clear
cls


* INCOME: SOI ------------------------------------------------------------------
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
	
	* check missings & feasibility
	mdesc
	su
	
	save "output/_yl_soi.dta", replace
}

* POVERTY: SAIPE ---------------------------------------------------------------
{
	use "output/id.dta", clear
	keep year fips
	
	merge 1:1 fips year using "data/Small Area Income and Poverty Estimates/saipe.dta"
	keep if _merge != 2
	drop _merge fips_state fips_county
	
	rename poverty_popu saipe_povertypopu
	rename poverty_pct saipe_povertyrate
	rename mid_finc saipe_midfinc
	
	* na & missings
	foreach var of varlist saipe_* {
		* interpolation: ounty time series
		bysort fips: mipolate `var' year, linear e gen(_tmp)
		replace `var' = _tmp if missing(`var')
		drop _tmp
	}
	
	* check missings & feasibility
	mdesc
	su
	
	save "output/_yl_saipe.dta", replace
	
}

* UNEMPLOYMENT: LAUS -----------------------------------------------------------
{
	use "output/id.dta", clear
	keep year fips
	
	merge 1:1 fips year using "data/Local Area Unemployment Statistics/laus.dta"
	keep if _merge != 2
	drop _merge fips_state fips_county
	
	* rename
	rename labor_force laus_laborforce
	rename emp_popu laus_emppopu
	rename unemp_popu laus_unemp_popu
	rename unemp_rate laus_urate
	
	* na & missings
	foreach var of varlist laus_* {
		* interpolation: ounty time series
		bysort fips: mipolate `var' year, linear e gen(_tmp)
		replace `var' = _tmp if missing(`var')
		drop _tmp
	}
	
	* check missings & feasibility
	mdesc
	su
	
	save "output/_yl_laus.dta", replace
	
}

* EMPLOYMENT: CBP --------------------------------------------------------------
{
	* preprocess cbp
	import delimited "data/Current Business Pattern/output/2003-2019.csv", ///
		clear delim(",")
	save "output/_cbp.dta", replace
	
	* process cbp with id
	use "output/id.dta", clear
	keep year fips
	
	* merge county CBP
	merge 1:1 fips year using "output/_cbp.dta"
	keep if _merge != 2
	gen flag_nointerp_cbp = _merge == 3 // flag to mark not-interpolated obs, including occasional missings
	la var flag_nointerp_cbp "Flag: Original CBP records without systemic missings"
	drop _merge
	
	// 	* detect systemic missings before 2017
	// 	* serious missings in employment series before 2017
	// 	gen x = missing(herfindahl) & (year < 2017)
	// 	bysort fips: egen xsum = sum(x)
	// 	keep fips xsum
	// 	duplicates drop
	// 	keep if xsum >= 10 // 2017-2003+1=15	
	
	* proc: fill occasional missings
	{
		* interpolation: 2003-2016, longitudinal, linear & backward, occasional missings (<100 missings per year)
		foreach v of varlist emp_* ap_* est_* {
			* linear interpolation
			qui bysort fips: mipolate `v' year if year < 2017, linear generate(_tmp)
			qui replace `v' = floor(_tmp) if missing(`v') & (!missing(_tmp))
			qui drop _tmp
			* forward and backward extrapolation
			qui bysort fips: mipolate `v' year if year < 2017, backward e generate(_tmp)
			qui replace `v' = floor(_tmp) if missing(`v') & (!missing(_tmp))
			qui replace `v' = 0 if (`v' < 0) & (!missing(`v')) & (!missing(_tmp))
			qui drop _tmp
			qui bysort fips: mipolate `v' year if year < 2017, forward e generate(_tmp)
			qui replace `v' = floor(_tmp) if missing(`v') & (!missing(_tmp))
			qui replace `v' = 0 if (`v' < 0) & (!missing(`v')) & (!missing(_tmp))
			qui drop _tmp
		}
		qui bysort fips: mipolate herfindahl year if year < 2017, linear generate(_tmp)
		qui replace herfindahl = _tmp if missing(herfindahl) & (!missing(_tmp))
		qui drop _tmp
		qui bysort fips: mipolate herfindahl year if year < 2017, backward e generate(_tmp)
		qui replace herfindahl = _tmp if missing(herfindahl) & (!missing(_tmp))
		qui drop _tmp
		qui bysort fips: mipolate herfindahl year if year < 2017, forward e generate(_tmp)
		qui replace herfindahl = _tmp if missing(herfindahl) & (!missing(_tmp))
		qui drop _tmp
	}
	
	* proc: fill systemic missings 2017-2019 using MA(3)
	{
		xtset fips year
		foreach v of varlist emp_* ap_* est_* herfindahl {
			forvalues t = 2017/2019 {
				qui gen _ma3 = floor(( l3.`v' + l2.`v' + l1.`v' )/3) if year == `t'
				qui replace `v' = _ma3 if missing(`v') & (!missing(_ma3))
				qui drop _ma3
			}
		}
		xtset, clear
		
	}
	
	* make: log Herfindahl index
	gen herfindahl_log = log(herfindahl)
	
	* renaming
	foreach v of varlist emp_* ap_* est_* herfindahl herfindahl_log {
		rename `v' cbp_`v'
	}
	order *, alpha
	order fips year
	
	* labelling
	la var cbp_ap_con "Annual payroll: construction, kilo dollar, CBP "
	la var cbp_ap_non "Annual payroll: non-tradablekilo dollar, CBP "
	la var cbp_ap_oth "Annual payroll: otherkilo dollar, CBP "
	la var cbp_ap_tra "Annual payroll: tradablekilo dollar, CBP "
	la var cbp_emp_con "Employment: construction, CBP "
	la var cbp_emp_non "Employment: non-tradable, CBP "
	la var cbp_emp_oth "Employment: other, CBP "
	la var cbp_emp_tra "Employment: tradable, CBP "
	la var cbp_est_con "Establishments: construction, CBP "
	la var cbp_est_non "Establishments: non-tradable, CBP "
	la var cbp_est_oth "Establishments: other, CBP "
	la var cbp_est_tra "Establishments: tradable, CBP "
	la var cbp_herfindahl "Herfindahl index, CBP "
	la var cbp_herfindahl_log "Log Herfindahl index, CBP "

	* check na & feasibility
	mdesc
	su
	
	* gc
	capture : erase "output/_cbp.dta"
	
	save "output/_yl_cbp.dta", replace
}


* EMPLOYMENT: CBP FWCP ---------------------------------------------------------
{
	* pre-process cbp fwcp data
	import delimited "data/Current Business Pattern/output/fwcp04-19.csv", ///
		delim(",") clear
	save "output/_fwcp.dta", replace
	

	use "output/id.dta", clear
	keep year fips
	
	merge 1:1 fips year using "output/_fwcp.dta"
	keep if _merge != 2
	drop _merge

	* labelling
	la var fwcp "Fraction of Wage Cuts Prevented"
	la var p "FWCP: incidence rate of nominal wage cuts in notional distribution"
	la var ptilde "FWCP: incidence rate of nominal wage cuts in actual distribution"

	* rename
	rename fwcp cbp_fwcp
	rename p cbp_p
	rename ptilde cbp_ptilde

	capture : erase "output/_fwcp.dta"
	
	save "output/_yl_fwcp.dta", replace
}


* MERGE ------------------------------------------------------------------------
{
	use "output/_yl_soi.dta", clear
	merge 1:1 fips year using "output/_yl_laus.dta", nogenerate
	merge 1:1 fips year using "output/_yl_saipe.dta", nogenerate
	merge 1:1 fips year using "output/_yl_cbp.dta", nogenerate
	merge 1:1 fips year using "output/_yl_fwcp.dta", nogenerate
	
	save "output/yl.dta", replace
	
	* gc
	capture : erase "output/_yl_soi.dta"
	capture : erase "output/_yl_laus.dta"
	capture : erase "output/_yl_saipe.dta"
	capture : erase "output/_yl_cbp.dta"
	capture : erase "output/_yl_fwcp.dta"
	
}

