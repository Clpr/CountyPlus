* PROCESS ICE BOA CORPORATE BOND INDEX AS FIXED INCOME PRICE

version 15

import excel using "original/BAMLCC0A0CMTRIV.xls", first cellrange(A11) clear
gen int year = year(observation_date)

rename BAMLCC0A0CMTRIV icecorpidx
la var icecorpidx "ICE BoA Corporate Bond Index, ICE & Fred"

drop observation_date

save "icecorpidx.dta", replace
