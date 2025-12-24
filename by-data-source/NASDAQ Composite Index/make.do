* PROCESS NASDAQ COMPOSITE INDEX TIME SERIES

version 15

import excel using "original/NASDAQCOM.xls", cellrange(A11) clear first

gen year = year(observation_date)
drop observation_date
rename NASDAQCOM nasdaq

la var nasdaq "NASDAQ Composite Index, Annual Avg, from Fred"

save "nasdaq.dta", replace