/*******************************************************************************
CountyPlus v0.0.2

SUPLLEMENTARY DATA:

NET WORTH SHOCK FOR ALL YEARS (2004-2019)
*******************************************************************************/
use "output/CountyPlus.dta", clear

xtset fips year

* lag
local L = 1

/******************************************************************************/
* notes: do not use log growth, due to: large change; negative net worth due to 
*        debt
gen N = nw / vpe_totpopu / ap_cpi // net worth per capita

gen nwshock_naive_unwinsored = d.N / l`L'.N
winsor2 nwshock_naive_unwinsored, suffix(_temp) cuts(1 99)
rename nwshock_naive_unwinsored_temp nwshock_naive
gen flag_nwshock_naive_winsored = nwshock_naive != nwshock_naive_unwinsored

/******************************************************************************/

* exposures (in fraction)
gen iv_shr_s = l`L'.nw_s / l`L'.nw // lagged share/exposure: stock/equity
gen iv_shr_b = l`L'.nw_b / l`L'.nw // lagged share/exposure: bond/fixed-income
gen iv_shr_h = l`L'.nw_h / l`L'.nw // lagged share/exposure: housing wealth

* state average house price change
egen _avg_hpi = wtmean(hpi), weight(vpe_totpopu) by(year fips_state)
replace _avg_hpi = log(_avg_hpi)

* aggregate asset price growth (in digital, not pct)
gen iv_gro_s = d`L'.ap_nasdaq / l`L'.ap_nasdaq         // lagged growth
gen iv_gro_b = d`L'.ap_icecorpidx / l`L'.ap_icecorpidx //
gen iv_gro_h = d`L'._avg_hpi                           //

* Identified net worth shock (in pct)
gen nwshock_unwinsored = (           ///
	iv_shr_s * iv_gro_s + ///
	iv_shr_b * iv_gro_b + ///
	iv_shr_h * iv_gro_h   ///
) * 100

* drop 2003 (due to lag operation)
drop if year == 2003

* winsorized
winsor2 nwshock_unwinsored, suffix(_temp) cuts(1 99)
rename nwshock_unwinsored_temp nwshock

* mark obs that were winsorized
gen flag_nwshock_winsored = nwshock != nwshock_unwinsored


/******************************************************************************/
* labeling
la var nwshock "Net worth shock (%): identified net worth shock"
la var nwshock_unwinsored "Net worth shock (%): identified net worth shock without winsorization"
la var flag_nwshock_winsored "Net worth shock (%): flag of winsorization"

la var nwshock_naive "Naive Net worth change (%): naive growth of real net worth per capita"
la var nwshock_naive_unwinsored "Naive Net worth change (%): naive growth of real net worth pc without winsorization"
la var flag_nwshock_naive_winsored "Naive Net worth change (%): flag of winsorization"


* save
keep fips year ///
	nwshock nwshock_unwinsored flag_nwshock_winsored ///
	nwshock_naive nwshock_naive_unwinsored flag_nwshock_winsored

save "output/NetWorthShock.dta", replace