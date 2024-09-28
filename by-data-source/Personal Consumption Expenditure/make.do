* CLEAN STATE-LEVEL PCE BY BEA

version 15


* INTERMEDIATE DATASET ---------------------------------------------------------
import delimited using "original/SAEXP2__ALL_AREAS_1997_2019.csv", ///
	varn(1) clear

* rename year columns
forvalues t = 9/31 {
	local YEAR = `t' + 1988
	rename v`t' pce`YEAR'
}

* make fips
gen fips = substr(geofips, 3, 5) // note: string not trimmed
destring fips, replace force
drop if missing(fips) // drop footnote lines
drop if fips == 0 // drop national level
gen int fips_state = floor(fips / 1000)

* slim
keep fips_state linecode description pce*

* save intermediate dataset
save "tmp.dta", replace


* PCE --------------------------------------------------------------------------
use "tmp.dta", clear
keep if linecode == 1
keep fips_state pce*
reshape long pce, i(fips_state) j(year)
la var pce "State PCE: total, BEA"
save "_pce.dta", replace

* DURABLE GOODS ----------------------------------------------------------------
use "tmp.dta", clear
keep if linecode == 3
keep fips_state pce*
reshape long pce, i(fips_state) j(year)
rename pce pce_dura
la var pce_dura "State PCE: durable goods, BEA"
save "_dura.dta", replace

* NON-DURABLE GOODS ------------------------------------------------------------
use "tmp.dta", clear
keep if linecode == 8
keep fips_state pce*
reshape long pce, i(fips_state) j(year)
rename pce pce_nond
la var pce_nond "State PCE: non-durable goods, BEA"
save "_nond.dta", replace

* SERVICE ----------------------------------------------------------------------
use "tmp.dta", clear
keep if linecode == 13
keep fips_state pce*
reshape long pce, i(fips_state) j(year)
rename pce pce_serv
la var pce_serv "State PCE: service, BEA"
save "_serv.dta", replace

* MERGE ------------------------------------------------------------------------
use "_pce.dta", clear
merge 1:1 fips_state year using "_dura.dta", nogen
merge 1:1 fips_state year using "_nond.dta", nogen
merge 1:1 fips_state year using "_serv.dta", nogen

save "pce.dta", replace


* GC
capture : erase "_pce.dta"
capture : erase "_dura.dta"
capture : erase "_nond.dta"
capture : erase "_serv.dta"
capture : erase "tmp.dta"

















