* CLEAN 2019 MEDIAN HOUSING VALUE USING 5-YEAR AND 1-YEAR ESTIMATES
/*
Following the methodology of National Association of Realtors (NAR), such that
using 1-year estimate if applicable (big counties), otherwise, use 5-year data
for the left counties. Check
`https://www.nar.realtor/research-and-statistics/housing-statistics/county-median-home-prices-and-monthly-mortgage-payment/methodology-median-home-value-and-monthly-mortgage-payment`

1. dp04_0089e: Estimate!!VALUE!!Owner-occupied units!!Median (dollars)


*/

version 15

clear all
cls

global FPATH = "original/DP04 - Selected housing characteristics/"

* PRE-PROCESS 5-YEAR ESTIMATES -------------------------------------------------
import delimited using "${FPATH}ACSDP5Y2019.DP04-Data.csv", ///
	delim(",") varn(1) rowrange(3) clear

keep geo_id name dp04_0089e

rename dp04_0089e mhv19_5y
destring mhv19_5y, replace force

gen fips = substr(geo_id, 10, 5)
destring fips, replace force

gen fips_state = floor(fips / 1000)
gen fips_county = mod(fips, 1000)

keep mhv19_5y fips fips_state fips_county

la var fips "5-digit county FIPS"
la var fips_state "State FIPS"
la var fips_county "3-digit county FIPS"
la var mhv19_5y "2019 Median house value, dollar, ACS 5-year estimates"

save "${FPATH}/_tmp5y.dta", replace


* PRE-PROCESS 1-YEAR ESTIMATES -------------------------------------------------
import delimited using "${FPATH}ACSDP1Y2019.DP04-Data.csv", ///
	delim(",") varn(1) rowrange(3) clear

keep geo_id name dp04_0089e

rename dp04_0089e mhv19_1y
destring mhv19_1y, replace force

gen fips = substr(geo_id, 10, 5)
destring fips, replace force

gen fips_state = floor(fips / 1000)
gen fips_county = mod(fips, 1000)

keep mhv19_1y fips fips_state fips_county

la var fips "5-digit county FIPS"
la var fips_state "State FIPS"
la var fips_county "3-digit county FIPS"
la var mhv19_1y "2019 Median house value, dollar, ACS 1-year estimates"

save "${FPATH}/_tmp1y.dta", replace


* MERGE ------------------------------------------------------------------------
use "${FPATH}/_tmp5y.dta", clear
merge 1:1 fips fips_state fips_county using "${FPATH}/_tmp1y.dta", nogen
gen mhv19 = mhv19_5y
replace mhv19 = mhv19_1y if !missing(mhv19_1y)
la var mhv19 "2019 Median house value, dollar, ACS 5-year and 1-year estimates"

* interpolation x-sectionally in-state
bysort fips_state: egen _avg = mean(mhv19)
replace mhv19 = _avg if missing(mhv19)
drop _avg

save "mhv19.dta", replace


* GC
capture : erase "${FPATH}/_tmp5y.dta"
capture : erase "${FPATH}/_tmp1y.dta"
