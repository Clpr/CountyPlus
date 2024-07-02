* land areas and others

import excel using "geographical.xlsx", ///
	firstrow case(lower) clear sheet("modified")

* make: numeric fips
destring fips, replace


* land areas
foreach var in landarea_km2 landarea_mi2 waterarea_km2 waterarea_mi2 totalarea_km2 totalarea_mi2 {
	rename `var' geo_`var'
}

* latitude & longitude
destring latitude, generate(geo_latitude)
destring longitude, generate(geo_longitude)


* labelling
la var geo_landarea_km2 "Geographic: land area (km^2)"
la var geo_landarea_mi2 "Geographic: land area (mi^2)"
la var geo_waterarea_km2 "Geographic: water area (km^2)"
la var geo_waterarea_mi2 "Geographic: water area (mi^2)"
la var geo_totalarea_km2 "Geographic: total area (km^2)"
la var geo_totalarea_mi2 "Geographic: total area (mi^2)"
la var geo_latitude "Geographic: latitude"
la var geo_longitude "Geographic: longitude"

keep fips geo_*

mdesc
save "landareas.dta", replace
