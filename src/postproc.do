* POST-CLEARNING PROCESS

version 15
clear
cls


* MAKE CONSUMPTION USING SALES TAX DATA ----------------------------------------
{
	use "output/_CountyPlus.dta", clear
	
	keep fips year pce tax_shar vpe_totpopu tax_dataflag
	
	gen c_agg = .
	gen c_avg = .
	gen c_logagg = .
	gen c_logavg = .
	
	bysort year: egen _tmp = sum(vpe_totpopu)
	
	* based on sales tax data
	replace c_agg = pce * _tmp * tax_shar
	replace c_avg = c_agg / vpe_totpopu
	replace c_logagg = log(c_agg)
	replace c_logavg = log(c_avg)
	
	drop _tmp
	
	keep fips year c_*
	
	
	
	
	la var c_agg "Consumption: $ county aggregate/total"
	la var c_avg "Consumption: $ per capita"
	la var c_logagg "Consumption: log($ county aggregate)"
	la var c_logavg "Consumption: log($ per capita)"
	
	save "output/_post_c.dta", replace
}






* MERGE BACK -------------------------------------------------------------------
{
	use "output/_CountyPlus.dta", clear
	
	merge 1:1 fips year using "output/_post_c.dta"
	keep if _merge != 2
	drop _merge
	
	
	save "output/CountyPlus.dta", replace
	
}


* GC 
capture : erase "output/_post_c.dta"

