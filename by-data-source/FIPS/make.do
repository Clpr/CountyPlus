* PROCESS STATE/COUNTY FIPS CODE AS PRIMY KEYS FOR MERGING
* Stata 17


* state FIPS
clear all
import delimited using "original/fips_state.csv", delim(",")
rename fips fips_state
rename name state_name
rename postalcode state_abbr

la var fips_state "FIPS of state"
la var state_name "State of the US"
la var state_abbr "Abbreviation of US states"

save "fips_state.dta", replace


* county FIPS
clear all
import delimited using "original/fips_county.csv", delim(",")
rename county county_name
gen fips = fips_state * 1000 + fips_county

la var fips_state "FIPS of state"
la var fips_county "3-digit county FIPS"
la var county_name "County name"
la var state_abbr "Abbreviation of US states"
la var fips "5-digit county FIPS"


* drop non-homeland state fips
drop if fips_state > 56

save "fips_county.dta", replace