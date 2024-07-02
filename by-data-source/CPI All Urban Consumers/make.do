* PROCESS CPI DATA

import excel "original/CPIAUCSL.xls", clear cellrange(A11) first
rename CPIAUCSL cpi
la var cpi "CPI All Urban Consumers (1982-1984=100)"
gen int year = year(observation_date)

keep year cpi

keep if (year < 2020) & (year > 2002)

save "cpi.dta", replace







