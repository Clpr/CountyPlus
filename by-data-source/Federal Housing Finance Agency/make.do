* CLEAN FHFA HPI COUNTY & NATIONAL DATA

version 15


* COUNTY DEV HPI ---------------------------------------------------------------
import excel using "original/HPI_AT_BDL_county.xlsx", clear cellrange(A7) first

* fips
destring FIPScode, replace force
gen long fips        = FIPScode
gen int fips_state  = floor(fips / 1000)
gen int fips_county = mod(fips, 1000)
gen int year        = Year

* HPIs
destring HPI, gen(_hpi) force

* slim
keep fips* _hpi year
drop if missing(fips)
keep if (2002 < year) & (year < 2020)

* interpolation
bysort fips: mipolate _hpi year, linear gen(hpi) epolate
drop _hpi

la var year "Year"
la var fips "5-digit county FIPS"
la var fips_state "State FIPS"
la var fips_county "3-digit county FIPS"
la var hpi "County Dev HPI, FHFA"

save "hpi.dta", replace



* NATIONAL DEV HPI -------------------------------------------------------------
import excel using "original/HPI_AT_BDL_national.xlsx", clear cellrange(A7) first

destring Year, gen(year) force
destring HPI, gen(hpi_national) force

keep year hpi_national
keep if year > 2002

la var year "Year"
la var hpi_national "National HPI, FHFA"

save "hpi_national.dta", replace


