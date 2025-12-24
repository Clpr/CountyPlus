* PROCESS FED FLOW OF FUNDS, ENHANCED FINANICAL ACCOUNTS, HOUSEHOLD DEBT

version 15

import delimited using "original/household-debt-by-county.csv", ///
	clear delim(",")
	
* fips
gen long fips = area_fips
gen int fips_state  = floor(fips / 1000)
gen int fips_county = mod(fips, 1000)

* interpolate missing `high`
bysort fips: mipolate high year, generate(_high) linear epolate

* fill the left missings with x-sectional state average
bysort year fips_state: egen _avg = mean(_high)
replace _high = _avg if missing(_high)
replace high = _high if missing(high)


* mid point of [low,high] as point estimate
gen d2y = (low + high) / 2

* aggregate quarters
bysort year fips: egen _lb = mean(low)
bysort year fips: egen _ub = mean(high)
bysort year fips: egen _pe = mean(d2y)
keep year fips _lb _ub _pe
duplicates drop

la var _lb "Debt-income ratio, lower bound, Flow of Funds, EFA"
la var _ub "Debt-income ratio, upper bound, Flow of Funds, EFA"
la var _pe "Debt-income ratio, Flow of Funds, EFA"

rename _lb ffof_efa_d2ylb
rename _ub ffof_efa_d2yub
rename _pe ffof_efa_d2y

save "d2y.dta", replace