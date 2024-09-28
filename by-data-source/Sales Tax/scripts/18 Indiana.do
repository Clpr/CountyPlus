* FIPS = 18 Indiana
* NOTE: call this from main.do

global STATECODE = "18 Indiana"
* amount -----------------------------------------------------------------------
import excel using "${STATECODE}/${STATECODE}.xlsx", ///
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
* we merged the catogery of gross sales and retail sales to "gross sales"
gen tax_rept = "gross sales"

* collect type:
* ("sales amount", "sales tax", "sales & use tax", "universal income tax")
gen tax_type = "sales amount"

* period type:
* ("fiscal year", "calendar year")
gen tax_ttpy = "calendar year"


* rate -------------------------------------------------------------------------

gen tax_rate = -2

* ("state", "local", "not applicable")
gen tax_rtpy = "not applicable"



* distribution -----------------------------------------------------------------

* recover sales
gen _tmp = tax_amnt // / tax_rate

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
gen tax_stpy = "original sales"


* ------------------------------------------------------------------------------
do "scripts/lavar.do"

save "output/${STATECODE}.dta", replace