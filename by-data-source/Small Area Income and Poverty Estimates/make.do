* PROCESS SAIPE DATA
* NOTES: pre-cleaned in excel

version 15

forvalues t = 2003/2019 {
	import excel using "original/est`t'all.xls", first clear sheet("cleaned")
	
	* unify data types
	capture : recast long fips_state fips_county
	capture : destring poverty_popu, replace
	capture : destring poverty_pct, replace
	capture : destring mid_finc, replace
	
	gen long fips = floor(fips_state * 1000 + fips_county)
	gen year = `t'
	
	save "`t'.dta", replace
}

clear
forvalues t = 2003/2019 {
	append using "`t'.dta"
	erase "`t'.dta"
}

la var poverty_popu "Poverty population, SAIPE"
la var poverty_pct "Poverty rate, SAIPE"
la var mid_finc "Median family income, dollar, SAIPE"

* slim
drop if missing(fips)
drop if fips_county == 0


save "saipe.dta", replace





