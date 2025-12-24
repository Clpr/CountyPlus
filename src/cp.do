/*******************************************************************************
TABLE: CONSUMPTION
*******************************************************************************/
version 15
clear
cls


* PCE: BEA DATA ----------------------------------------------------------------
{
	use "output/id.dta", clear
	keep year fips fips_state
	
	* merge: PCE
	merge m:1 fips_state year using "data/Personal Consumption Expenditure/pce.dta"
	keep if _merge != 2
	drop _merge fips_state
	
	
	* check missings & feasibility
	mdesc
	su
	
	save "output/_cp_pce.dta", replace
}


* SALES TAX DATA ---------------------------------------------------------------
{
	use "output/id.dta", clear
	keep year fips fips_state fips_county
	
	* merge: sales tax data
	merge 1:1 fips_state fips_county year using "data/Sales Tax/output/salestax.dta"
	keep if _merge != 2
	drop _merge fips_state fips_county
	
	* check missings & feasibility
	mdesc
	su
	
	save "output/_cp_salestax.dta", replace
}



* MERGE ------------------------------------------------------------------------
{
	use "output/_cp_pce.dta", clear
	merge 1:1 fips year using "output/_cp_salestax.dta", nogenerate
	
	* flag: sales tax data
	gen tax_dataflag = 0
	replace tax_dataflag = 1 if !missing(tax_amnt)
	la var tax_dataflag "Sales tax data: flag marking if the observation has sales tax data"
}


* SAVE -------------------------------------------------------------------------
{
	save "output/cp.dta", replace
	
	* gc
	capture : erase "output/_cp_pce.dta"
	capture : erase "output/_cp_salestax.dta"	
}
