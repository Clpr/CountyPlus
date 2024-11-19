* COUNTYPLUS DATASET
/*
Version: Mar 30, 2023

1. We first generate sub-datasets for different topics of variables. Then, we me
rge them up to the final CountyPlus data. Use `id.dta` as left table, always do
left joins.

*/


* Table: ID
/*
Data sources: FIPS

This table will be used to build other tables
Data sources: FIPS
Dependencies: None
Output      : output/id.dta
*/
qui do "src/id.do"


* Table: Household balance sheet
/*
Data sources: FFoF, SOI, FFoF-EFA, HPI, ACS, Census
Dependencies: id.dta
Output      : output/bs.dta
*/
qui do "src/bs.do"


* Table: Income, poverty, and labor market
/*
Data sources: SOI, LAUS, SAIPE, CBP
Dependencies: id.dta
Output      : output/yl.dta
*/
qui do "src/yl.do"


* Table: Aggregate prices
/*
Data sources: NASDAQ, CPI, ICE-BondIndex
Dependencies: id.dta
Output      : output/ap.dta
*/
qui do "src/ap.do"



* Table: Consumption
/*
Data sources: BEA-PCE, Local DoR
Dependencies: id.dta
Output      : output/cp.dta
*/
qui do "src/cp.do"



* Table: Land and Geography
/*
Data sources: Land Unavailability
Dependencies: id.dta
Output      : output/lg.dta
*/
qui do "src/lg.do"



* Table: Demography
/*
Data sources: CENSUS,
Dependencies: id.dta
Output      : output/dm.dta
*/
qui do "src/dg.do"

* Table: Credit supply
/*
Data sources: HMDA,
Dependencies: id.dta
Output      : output/cs.dta
*/
qui do "src/cs.do"



* Merge
/*
Output: output/CountyPlus.dta
*/
{
	use "output/id.dta", clear
	merge 1:1 fips year using "output/bs.dta", nogenerate
	merge 1:1 fips year using "output/yl.dta", nogenerate
	merge m:1      year using "output/ap.dta", nogenerate
	merge 1:1 fips year using "output/cp.dta", nogenerate
	merge 1:1 fips year using "output/lg.dta", nogenerate
	merge 1:1 fips year using "output/dg.dta", nogenerate
	merge 1:1 fips year using "output/cs.dta", nogenerate
	
	mdesc
	su
	save "output/_CountyPlus.dta", replace
}

 

* Post processes
/*
Output: output/CountyPlus.dta
*/
qui do "src/postproc.do"



* CountyPlus v0.0.2
/*
Output: output/NetWorthShock.dta
*/
qui do "src/networthshock.do"

