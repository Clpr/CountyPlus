/*******************************************************************************
TABLE: AGGREGATE PRICES

NOTE: this table is (year,) but not (county,year)
*******************************************************************************/

clear
cls

* NASDAQ -----------------------------------------------------------------------
{
	use "data/NASDAQ Composite Index/nasdaq.dta", clear
	rename nasdaq ap_nasdaq
	save "output/_ap_nasdaq.dta", replace
}

* ICE BOA CORPORATE BOND MARKET INDEX  -----------------------------------------
{
	use "data/ICE BofA US Corporate Index/icecorpidx.dta", clear
	rename icecorpidx ap_icecorpidx
	save "output/_ap_ice.dta", replace
}

* CPI ALL URBAN CONSUMER -------------------------------------------------------
{
	use "data/CPI All Urban Consumers/cpi.dta", clear
	rename cpi ap_cpi
	save "output/_ap_cpi.dta", replace
}

* MERGE ------------------------------------------------------------------------
{
	use "output/_ap_nasdaq.dta", replace
	merge 1:1 year using "output/_ap_ice.dta", nogenerate
	merge 1:1 year using "output/_ap_cpi.dta", nogenerate
	keep if (year > 2002) & (year < 2020)
	
	mdesc
	
	capture : erase "output/_ap_nasdaq.dta"
	capture : erase "output/_ap_ice.dta"
	capture : erase "output/_ap_cpi.dta"
	
	save "output/ap.dta", replace
}


