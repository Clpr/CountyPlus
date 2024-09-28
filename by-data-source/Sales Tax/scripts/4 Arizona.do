* FIPS = 4, Arizona
* NOTE: call this from main.do


* amount -----------------------------------------------------------------------
import excel using "4 Arizona/4 Arizona.xlsx", ///
	sheet("tax") ///
	case(lower)  ///
	firstrow     ///
	clear
reshape long taxrev_sales_, i(state county fips_state fips_county) j(year)


rename taxrev_sales_ tax_amnt


* scale/unit -------------------------------------------------------------------
gen tax_unit = "dollar"


* type -------------------------------------------------------------------------

* report type:
* ("gross sales", "taxable sales", "state collection", "local collection")
gen tax_rept = "local collection"

* collect type:
* ("sales tax", "sales & use tax", "universal income tax")
gen tax_type = "universal income tax"

* period type:
* ("fiscal year", "calendar year")
gen tax_ttpy = "fiscal year"


* rate -------------------------------------------------------------------------

gen tax_rate = -1

* ("state", "local")
gen tax_rtpy = "local"



* distribution -----------------------------------------------------------------

* direct share
bysort year: egen _trash = sum(tax_amnt)
gen tax_shar = tax_amnt / _trash
drop _trash

* log share (i.e. log / sum(log))
gen _trash1 = log(tax_amnt)
bysort year: egen _trash2 = sum(_trash1)
gen tax_lshr = _trash1 / _trash2
drop _trash1 _trash2

* based on what the share/distribution is computed
* ("original sales", "original collection", "recovered sales", "recovered collection")
gen tax_stpy = "original collection"


* ------------------------------------------------------------------------------
do "scripts/lavar.do"

save "output/${STATECODE}.dta", replace