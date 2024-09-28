* MERGE CLEANED SOI DATA AND EXPORT AS STATA FILE


version 15

* 03-12 data
{
	import delimited using "output/soi0312.csv", delim(",") clear
	keep fips_state fips_county adjusted_gross_income salaries_and_wages_in_agi ///
		ordinary_dividends_before_exclus taxable_interest year

	* drop identical duplicates and state aggregate (fips county=0)
	drop if fips_county == 0
	duplicates drop fips_state fips_county year, force
		
	save "_0312.dta", replace
}

* 12-19 data & append & format
{
	import excel using "output/soi1319.xlsx", clear first
	drop if fips_county == 0
	duplicates drop fips_state fips_county year, force
	
	append using "_0312.dta"
	
	* formating
	recast long fips_state
	recast long fips_county
	recast int  year
	gen long fips = floor(fips_state * 1000 + fips_county)
	
	* labelling
	rename adjusted_gross_income            soi_agi
	rename salaries_and_wages_in_agi        soi_sws
	rename ordinary_dividends_before_exclus soi_div
	rename taxable_interest                 soi_int
	
	la var soi_agi "Adjusted gross income, kilo dollar, SOI"
	la var soi_sws "Salaries and wages in AGI, kilo dollar, SOI"
	la var soi_div "Ordinary dividends before tax, kilo dollar, SOI"
	la var soi_int "Taxable interest, kilo dollar, SOI"
	
	* fill na (rare), time series
	foreach var in agi sws div int {
		bysort fips: mipolate soi_`var' year, linear epolate gen(_tmp)
		replace soi_`var' = _tmp if missing(soi_`var')
		drop _tmp
	}
	
	
	* gc
	erase "_0312.dta"
	
	save "soi.dta", replace
}


