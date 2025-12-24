/*******************************************************************************
TABLE: DEMOGRAPHICS
*******************************************************************************/
version 15
clear
cls

* CENSUS: POPULATION -----------------------------------------------------------
{
	use "output/id.dta", clear
	keep year fips
	
	* merge: census vintage population
	merge 1:1 fips year using "data/Vintage Population Estimates for Demographics/output/vpe.dta"
	keep if _merge != 2
	drop _merge
	
	drop fips_state fips_county
	
	* check missings & feasibility
	mdesc
	su
	
	save "output/_dg_popu.dta", replace
}

* USDA: EDUCATION ATTAINMENT ---------------------------------------------------
{
	use "output/id.dta", clear
	keep year fips fips_state
	
	* merge: census vintage population
	merge m:1 fips using "data/USDA Educational Attainment for adults/usdaedu.dta"
	keep if _merge != 2
	drop _merge
	
	
	* check missings & feasibility
	mdesc
	su
	
	save "output/_dg_edu.dta", replace
}



* MERGE
{
	use "output/_dg_popu.dta", replace
	merge 1:1 fips year using "output/_dg_edu.dta", nogenerate
	
	save "output/dg.dta", replace
	
	capture : erase "output/_dg_popu.dta"
	capture : erase "output/_dg_edu.dta"
}
