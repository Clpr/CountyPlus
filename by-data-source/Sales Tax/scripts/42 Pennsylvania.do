* FIPS = 42 Pennsylvania
* NOTE: call this from main.do

global STATECODE = "42 Pennsylvania"
* amount -----------------------------------------------------------------------
import excel using "${STATECODE}/${STATECODE}.xlsx", ///
	sheet("tax") ///
	case(lower)  ///
	firstrow     ///
	clear
reshape long taxrev_sales_, i(state county fips_state fips_county) j(year)


rename taxrev_sales_ tax_amnt


* scale/unit -------------------------------------------------------------------
gen tax_unit = "thousands of dollars"


* type -------------------------------------------------------------------------

* report type:
* ("gross sales", "taxable sales", "state collection", "local collection")
gen tax_rept = "local collection"

* collect type:
* ("sales tax", "sales & use tax", "universal income tax")
gen tax_type = "sales & use tax"

* period type:
* ("fiscal year", "calendar year")
gen tax_ttpy = "fiscal year"


* rate -------------------------------------------------------------------------

capture : drop _tmp.dta
save "_tmp.dta", replace


import excel using "${STATECODE}/${STATECODE}.xlsx", ///
	sheet("rate") ///
	case(lower)  ///
	firstrow     ///
	clear
reshape long taxrev_sales_, i(state county fips_state fips_county) j(year)
gen tax_rate = taxrev_sales_ / 100
drop taxrev_sales_

* ("state", "local")
gen tax_rtpy = "local"


* merge w/ amount
merge 1:1 state county fips_state fips_county year using "_tmp.dta", nogenerate

* gc
capture : erase _tmp.dta




* distribution -----------------------------------------------------------------

* recover sales
gen _tmp = tax_amnt / tax_rate

* direct share
bysort year: egen _trash = sum(_tmp)
gen tax_shar = _tmp / _trash
drop _trash

* log share (i.e. log / sum(log))
gen _trash1 = log(_tmp)
bysort year: egen _trash2 = sum(_trash1)
gen tax_lshr = _trash1 / _trash2
drop _trash1 _trash2

drop _tmp

* based on what the share/distribution is computed
* ("original sales", "original collection", "recovered sales", "recovered collection")
gen tax_stpy = "recovered sales"


* ------------------------------------------------------------------------------
do "scripts/lavar.do"

save "output/${STATECODE}.dta", replace