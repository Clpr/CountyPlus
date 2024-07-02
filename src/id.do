/*******************************************************************************
TABLE: ID
*******************************************************************************/

clear
cls

* temp year aux df
set obs 17 // 03-19
gen year = _n + 2002
save "_tmp.dta", replace

* expand (county,) to (county,year)
use "data/FIPS/fips_county.dta", clear

* recast fips
recast long fips

* Cartesian
cross using "_tmp.dta"


* drop some special census areas and merged counties and/or equivalences
{
	* SYSTEMIC MISSINGS DUE TO ADMIN CHANGES & SOI SYSTEMIC MISSINGS
	{
		* Reference: CDC County Geography changes documentations
		
		drop if fips_state > 56 // overseas lands
		
		* VIRGINIA
		drop if fips == 51780 // Virginia, 1995: The independent city of South Boston (51780) merged into Halifax county (51083)
		drop if fips == 51560 // Virginia, 2001: The independent city of Clifton Forge (FIPS 51560) merges into Alleghany county (FIPS 51005).
		drop if fips == 51515 // Virginia, 2013: The independent city of Bedford (FIPS 51515) merges into Bedford County (FIPS 51019).
		
		* SOUTH DAKOTA
		drop if inlist(fips,46113,46102) // South Dakota, 2015: Shannon County (FIPS 46113) is renamed to Oglala Lakota County (FIPS 46102). Action: replace FIPS code 46102 with the old code 46113
		
		* MONTANA
		drop if fips == 30113 // Montana, 1997: Yellowstone National Park territory (FIPS 30113) is merged into Gallatin (FIPS 30031) and Park (FIPS 30067) counties. Action: no adjustment of the source data required since all three territories map to the same CZ 34402
		
		* DC
		drop if fips == 11001 // Some data sources report the FIPS code for the single county of the District of Columbia as 11999 instead of 11001
		
		* AKANSA
		drop if fips == 02280 // Petersburg Census Area, AK (FIPS code=02195). Petersburg Census Area was created from part of the former Wrangell-Petersburg Census Area (FIPS code = 02280) in 2008. This entity has a category code in the 2013 and 2006 NCHS schemes, but not in the 1990  census-based scheme.
		drop if fips == 02270 // Kusilvak Census Area, AK (FIPS code = 02158). Wade-Hampton Census Area, AK (02270 was renamed Kusilvak, AK and assigned a new FIPS code (02158) effective in 2014. Kusilvak has a category code in all three of the NCHS schemes
		drop if fips == 02232 // Hoonah-Angoon Census Area, AK (FIPS code = 02105). In 2007, Skagway-Hoonah Angoon Census Area (FIPS code = 02232) was split into Hoonah-Angoon Census Area and Skagway Municipality (FIPS code = 02230). Hoonah-Angoon Census Area has a category code in the 2013 and 2006 NCHS schemes, but not in the 1990 census-based scheme. 
		drop if fips == 02201 // Prince of Wales-Hyder Census Area, AK (FIPS code = 02198). In 2008, Prince of Wales Hyder Census Area was created from the remainder of the former Prince of Wales-Outer Ketchikan Census Area (FIPS code = 02201) after part (Outer Ketchikan) was annexed by  Ketchikan Gateway Borough (FIPS code = 02130and another part was included in the new  Wrangell Borough. This entity has a category code in the 2013 and 2006 NCHS schemes, but not in the 1990 census-based scheme.

		* TEXAS
		drop if fips == 48301 // Loving County, TX; outlier esp. income
	}
	
	* SYSTEMIC MISSINGS IN CBP DATA (ALL YEAR UNAVAILABLE)
	{
		drop if fips == 48271 // Kinney County, TX
		drop if fips == 48269 // King County, TX
		drop if fips == 48261 // Kenedy County, TX
		drop if fips == 48173 // Glasscock County, TX
		drop if fips == 48137 // Edwards County, TX
		drop if fips == 48033 // Borden County, TX
		drop if fips == 46095 // Mellette County, SD
		drop if fips == 41069 // Wheeler County, OR
		drop if fips == 38085 // Sioux County, ND
		drop if fips == 31165 // Sioux County, NE
		drop if fips == 31117 // McPherson County, NE
		drop if fips == 31061 // Franklin County, NE
		drop if fips == 31049 // Deuel County, NE
		drop if fips == 31009 // Blaine County, NE
		drop if fips == 31007 // Banner County, NE
		drop if fips == 30069 // Petroleum County, NT
		drop if fips == 28063 // Jefferson County, MS
		drop if fips == 28055 // Issaquena County, MS
		drop if fips == 21201 // Robertson County, KY
		drop if fips == 21063 // Elliott County, KY
		drop if fips == 13125 // Glascock County, GA
		drop if fips == 8025  // Crowley County, CO
		
		* if employment/payroll/establishment data missing > 10 years out of the
		* total 15 years from 2003 to 2017
		drop if fips == 6003
		drop if fips == 13007
		drop if fips == 20097
		drop if fips == 27087
		drop if fips == 30103
		drop if fips == 31115
		drop if fips == 35021
		drop if fips == 38001
		drop if fips == 38007
		drop if fips == 38087
		drop if fips == 41055
		drop if fips == 46069
		drop if fips == 46075
		drop if fips == 46085
		drop if fips == 48125
		drop if fips == 48243
		drop if fips == 48433
		drop if fips == 48443
		drop if fips == 49009
		drop if fips == 53023

		* if Herfindahl missing > 10 years out of the 15 years (2003-2017)
		drop if fips == 2282
		drop if fips == 8053
		drop if fips == 13061
		drop if fips == 13101
		drop if fips == 13265
		drop if fips == 16033
		drop if fips == 20083
		drop if fips == 21189
		drop if fips == 30033
		drop if fips == 30037
		drop if fips == 30079
		drop if fips == 31005
		drop if fips == 31075
		drop if fips == 31085
		drop if fips == 31091
		drop if fips == 31103
		drop if fips == 31113
		drop if fips == 31183
		drop if fips == 32009
		drop if fips == 40057
		drop if fips == 41021
		drop if fips == 46017
		drop if fips == 46031
		drop if fips == 48011
		drop if fips == 48101
		drop if fips == 48155
		drop if fips == 48263
		drop if fips == 48311
		drop if fips == 48393
		drop if fips == 49031
		drop if fips == 55078
		
	}
	
	
	
}





* gc
capture : erase "_tmp.dta"

* save
save "output/id.dta", replace