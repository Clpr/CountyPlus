/*******************************************************************************
TABLE: CREDIT SUPPLY
*******************************************************************************/
version 15
clear
cls

* HMDA -------------------------------------------------------------------------
{
	use "output/id.dta", clear
	keep year fips fips_state fips_county
	
	* merge: PCE
	merge 1:1 fips_state fips_county year using "data/Home Mortgage Disclosure Act/hmda.dta"
	keep if _merge != 2
	drop _merge fips_state fips_county
	
	
	* check missings & feasibility
	mdesc
	su
	
	save "output/cs.dta", replace
}











