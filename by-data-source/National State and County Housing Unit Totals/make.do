* PROCESS HOUSING UNITS ESTIMATES BY CENSUS BUREAU

* 2000-2010 --------------------------------------------------------------------
import delimited "original/hu-est00int-tot.csv", delim(",") clear
gen long fips = floor(state * 1000 + county)
keep fips huest_2000-huest_2009
drop if missing(fips) | (fips == 0)
reshape long huest_, i(fips) j(year)
rename huest_ cb_huest
save "_tmp.dta", replace



* 2010-2020 --------------------------------------------------------------------
import delimited "original/HU-EST2020_ALL.csv", delim(",") clear
gen long fips = floor(state * 1000 + county)
keep fips huestimate*
drop if missing(fips) | (fips == 0)
drop huestimatesbase2010 huestimate042020
reshape long huestimate, i(fips) j(year)
rename huestimate cb_huest
* append
append using "_tmp.dta"

la var cb_huest "Total housing units estimates, Census Bureau"

capture : erase "_tmp.dta"
save "thu.dta", replace
