/*******************************************************************************
TABLE: LAND & GEOGRAPHIC CHARACTERISTICS
*******************************************************************************/
version 15
clear
cls


* LAND UNAVAILABILITY ----------------------------------------------------------
{
	import delimited using "data/Land Unavailability/archive/20-us_county2000_total_unavailable.csv", ///
		delim(",") varnames(1) case(lower) clear
	rename geoid fips
	rename totalunavailable gislu_total
	keep fips gislu_*
	
	la var gislu_total "GIS Land Unavailability 2000: total unavailable land index"

	save "output/_lg_lu.dta", replace
		
	* merge:
	use "output/id.dta", clear
	keep year fips
	
	merge m:1 fips using "output/_lg_lu.dta"
	keep if _merge != 2
	drop _merge
	
	
	* check missings & feasibility
	mdesc
	su
	
	save "output/_lg_lu.dta", replace
}

* LNAD AREAS & LATI-LONG -------------------------------------------------------
{
	* merge:
	use "output/id.dta", clear
	keep year fips
	
	merge m:1 fips using "data/County Land Areas/landareas.dta"
	keep if _merge != 2
	drop _merge
	
	
	* check missings & feasibility
	mdesc
	su
	
	save "output/_lg_la.dta", replace
}





* MERGE
{
	use "output/_lg_lu.dta", replace
	merge 1:1 fips year using "output/_lg_la.dta", nogenerate
	
	save "output/lg.dta", replace
	
	capture : erase "output/_lg_lu.dta"
	capture : erase "output/_lg_la.dta"
}
