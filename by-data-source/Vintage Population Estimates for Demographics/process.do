* processing age, gender, and sex data
/*
OUTPUT VARIABLES:

1. fips state & county
2. year (using latest estimate if there are multiple dates)
3. total population
4. total population by sex (male, female)
5. total population of working age (15 <= age < 70)
6. total population by race (white, black)
7. median age
8. average age

*/


/******************************************************************************/
* 2011 - 2019 (single file)
foreach t of numlist 2011/2019 {
	
	* t-2007 to math year code
	* YEAR: keep only year == `t'-2007, `t'-2007 = 7/1/`t' population estimate
	
	clear
	import delimited "2010-`t'/cc-est`t'-alldata.csv"
	keep if year == `t'-2007 // latest estimate for the current year
	drop if agegrp == 0 // this is sum of all age groups, drop, we sum manually
	drop year
	
	* IDs
	gen fips_state  = state
	gen fips_county = county
	gen year = `t'
	
	* total population & by sex
	bysort fips_state fips_county: egen vpe_totpopu = sum(tot_pop)
	la var vpe_totpopu "Total population, CensusBureau Vintage Population Estimate"
	
	bysort fips_state fips_county: egen vpe_totpopu_male = sum(tot_male)
	la var vpe_totpopu_male "Total male population, CensusBureau Vintage Population Estimate"
	
	bysort fips_state fips_county: egen vpe_totpopu_female = sum(tot_female)
	la var vpe_totpopu_female "Total female population, CensusBureau Vintage Population Estimate"
	
	* population by race
	bysort fips_state fips_county: egen vpe_totpopu_white = sum(wa_male + wa_female)
	la var vpe_totpopu_white "Total white population, CensusBureau Vintage Population Estimate"
	
	bysort fips_state fips_county: egen vpe_totpopu_black = sum(ba_male + ba_female)
	la var vpe_totpopu_black "Total black population, CensusBureau Vintage Population Estimate"
	
	* average age
	gen _midage = .
	replace _midage = 2 if agegrp == 1 // 0-4
	replace _midage = 7 if agegrp == 2 // 5-9
	replace _midage = 12 if agegrp == 3 // 10-14
	replace _midage = 17 if agegrp == 4 // 15-19
	replace _midage = 22 if agegrp == 5 // 20-24
	replace _midage = 27 if agegrp == 6 // 25-29
	replace _midage = 32 if agegrp == 7 // 30-34
	replace _midage = 37 if agegrp == 8 // 35-39
	replace _midage = 42 if agegrp == 9 // 40-44
	replace _midage = 47 if agegrp == 10 // 45-49
	replace _midage = 52 if agegrp == 11 // 50-54
	replace _midage = 57 if agegrp == 12 // 55-59
	replace _midage = 62 if agegrp == 13 // 60-64
	replace _midage = 67 if agegrp == 14 // 65-69
	replace _midage = 72 if agegrp == 15 // 70-74
	replace _midage = 77 if agegrp == 16 // 75-79
	replace _midage = 82 if agegrp == 17 // 80-84
	replace _midage = 87 if agegrp == 18 // >=85
	bysort fips_state fips_county: egen vpe_avgage = wtmean(_midage), weight(tot_pop)
	la var vpe_avgage "Average age, CensusBureau Vintage Population Estimate"
	
	* population of working age
	bysort fips_state fips_county: egen vpe_totpopu_work = sum(tot_pop) if agegrp > 3 & agegrp < 15
	la var vpe_totpopu_work "Total working age population from age 15-70, CensusBureau Vintage Population Estimate"
	
	* slim
	keep fips_* year vpe_*
	drop if missing(vpe_totpopu_work)
	duplicates drop
	
	* save
	save "output/raw`t'.dta", replace
	
	
}

/******************************************************************************/
* 2003-2010 (multiple files), appending by-state files
* only needs to run once
* pause Dropbox sync while this block since many temporary files generated 
foreach t of numlist 2003/2010 {
	clear
	if `t' == 2004 {
		global PREFIX = "cc_est2004_alldata_"
	}
	else if `t' == 2010 {
		global PREFIX = "co-est00int-alldata-"
	}
	else {
		global PREFIX = "cc-est`t'-alldata-"
	}
	
	* import and save
	foreach i of numlist 1 2 4 5 6 8/13 15/42 44/51 53/56 {
		disp "Importing year `t' of state `i' csv ..."
		if `i' < 10 {
			qui import delimited "2000-`t'/${PREFIX}0`i'.csv", clear
		} 
		else {
			qui import delimited "2000-`t'/${PREFIX}`i'.csv", clear
		}
		
		* special cases
		if `t' == 2008 & inlist(`i',2,8) {
			destring tot_pop tot_male tot_female wa_male wa_female ba_male ba_female ia_male ia_female aa_male aa_female na_male na_female tom_male tom_female wac_male wac_female bac_male bac_female iac_male iac_female aac_male aac_female nac_male nac_female nh_male nh_female nhwa_male nhwa_female nhba_male nhba_female nhia_male nhia_female nhaa_male nhaa_female nhna_male nhna_female nhtom_male nhtom_female nhwac_male nhwac_female nhbac_male nhbac_female nhiac_male nhiac_female nhaac_male nhaac_female nhnac_male nhnac_female h_male h_female hwa_male hwa_female hba_male hba_female hia_male hia_female haa_male haa_female hna_male hna_female htom_male htom_female hwac_male hwac_female hbac_male hbac_female hiac_male hiac_female haac_male haac_female hnac_male hnac_female, force replace
		}
		if `t' == 2009 & inlist(`i',2,8) {
			destring tot_pop tot_male tot_female wa_male wa_female ba_male ba_female ia_male ia_female aa_male aa_female na_male na_female tom_male tom_female wac_male wac_female bac_male bac_female iac_male iac_female aac_male aac_female nac_male nac_female nh_male nh_female nhwa_male nhwa_female nhba_male nhba_female nhia_male nhia_female nhaa_male nhaa_female nhna_male nhna_female nhtom_male nhtom_female nhwac_male nhwac_female nhbac_male nhbac_female nhiac_male nhiac_female nhaac_male nhaac_female nhnac_male nhnac_female h_male h_female hwa_male hwa_female hba_male hba_female hia_male hia_female haa_male haa_female hna_male hna_female htom_male htom_female hwac_male hwac_female hbac_male hbac_female hiac_male hiac_female haac_male haac_female hnac_male hnac_female, force replace
		}
		
		
		qui save "tmp`i'.dta", replace
	}
	clear
	foreach i of numlist 1 2 4 5 6 8/13 15/42 44/51 53/56 {
		disp "Appending year `t' of state `i'..."
		qui append using "tmp`i'.dta"
		qui erase "tmp`i'.dta"
	}
	* save a big file
	qui save "2000-`t'/raw`t'.dta", replace
	
}




/******************************************************************************/
* 2004-2010 (multiple files), process the appended files
foreach t of numlist 2004/20010 {
	
	* t-1997 to math year code
	* YEAR: keep only year == `t'-1997, `t'-1997 = 7/1/`t' population estimate
	clear
	use "2000-`t'/raw`t'.dta"
	if `t' == 2004 {
		keep if year == "2004"
	}
	else {
		keep if year == `t'-1997 // latest estimate for the current year
	}
	drop if agegrp == 0 // this is sum of all age groups, drop, we sum manually
	drop year
	
	* IDs
	gen fips_state  = state
	gen fips_county = county
	gen year = `t'
	
	* total population & by sex
	bysort fips_state fips_county: egen vpe_totpopu = sum(tot_pop)
	la var vpe_totpopu "Total population, CensusBureau Vintage Population Estimate"
	
	bysort fips_state fips_county: egen vpe_totpopu_male = sum(tot_male)
	la var vpe_totpopu_male "Total male population, CensusBureau Vintage Population Estimate"
	
	bysort fips_state fips_county: egen vpe_totpopu_female = sum(tot_female)
	la var vpe_totpopu_female "Total female population, CensusBureau Vintage Population Estimate"
	
	* population by race
	bysort fips_state fips_county: egen vpe_totpopu_white = sum(wa_male + wa_female)
	la var vpe_totpopu_white "Total white population, CensusBureau Vintage Population Estimate"
	
	bysort fips_state fips_county: egen vpe_totpopu_black = sum(ba_male + ba_female)
	la var vpe_totpopu_black "Total black population, CensusBureau Vintage Population Estimate"
	
	* average age
	gen _midage = .
	replace _midage = 2 if agegrp == 1 // 0-4
	replace _midage = 7 if agegrp == 2 // 5-9
	replace _midage = 12 if agegrp == 3 // 10-14
	replace _midage = 17 if agegrp == 4 // 15-19
	replace _midage = 22 if agegrp == 5 // 20-24
	replace _midage = 27 if agegrp == 6 // 25-29
	replace _midage = 32 if agegrp == 7 // 30-34
	replace _midage = 37 if agegrp == 8 // 35-39
	replace _midage = 42 if agegrp == 9 // 40-44
	replace _midage = 47 if agegrp == 10 // 45-49
	replace _midage = 52 if agegrp == 11 // 50-54
	replace _midage = 57 if agegrp == 12 // 55-59
	replace _midage = 62 if agegrp == 13 // 60-64
	replace _midage = 67 if agegrp == 14 // 65-69
	replace _midage = 72 if agegrp == 15 // 70-74
	replace _midage = 77 if agegrp == 16 // 75-79
	replace _midage = 82 if agegrp == 17 // 80-84
	replace _midage = 87 if agegrp == 18 // >=85
	bysort fips_state fips_county: egen vpe_avgage = wtmean(_midage), weight(tot_pop)
	la var vpe_avgage "Average age, CensusBureau Vintage Population Estimate"
	
	* population of working age
	bysort fips_state fips_county: egen vpe_totpopu_work = sum(tot_pop) if agegrp > 3 & agegrp < 15
	la var vpe_totpopu_work "Total working age population from age 15-70, CensusBureau Vintage Population Estimate"
	
	* slim
	keep fips_* year vpe_*
	drop if missing(vpe_totpopu_work)
	duplicates drop
	
	* save
	save "output/raw`t'.dta", replace
	
	
}


* 2003 (older data structure)
* NOTES: in 2003, agegrp = 0, sex = 0, origin = 0,
*        and race = 0 need to be dropped
foreach t in 2003 {
	clear
	use "2000-`t'/raw`t'.dta"
	drop if age == 0 // this is sum of all age groups, drop, we sum manually
	drop if sex == 0
	drop if origin == 0
	drop if race == 0
	
	gen year = `t'
	
	* make fips
	tostring stcty, generate(_f)
	gen fips_county = ""
	replace fips_county = substr(_f,2,4) if strlen(_f) == 4
	replace fips_county = substr(_f,3,5) if strlen(_f) == 5
	gen fips_state = ""
	replace fips_state = substr(_f,1,1) if strlen(_f) == 4
	replace fips_state = substr(_f,1,2) if strlen(_f) == 5
	destring fips_state fips_county, replace force
	
	gen tot_pop = popestimate2003
	gen tot_male = popestimate2003 if sex == 1
	gen tot_female = popestimate2003 if sex == 2
	gen wa = popestimate2003 if race == 1
	gen ba = popestimate2003 if race == 2
	gen agegrp = age
	
	* total population & by sex
	bysort fips_state fips_county: egen vpe_totpopu = sum(tot_pop)
	la var vpe_totpopu "Total population, CensusBureau Vintage Population Estimate"
	
	bysort fips_state fips_county: egen vpe_totpopu_male = sum(tot_male)
	la var vpe_totpopu_male "Total male population, CensusBureau Vintage Population Estimate"
	
	bysort fips_state fips_county: egen vpe_totpopu_female = sum(tot_female)
	la var vpe_totpopu_female "Total female population, CensusBureau Vintage Population Estimate"
	
	
	* population by race
	bysort fips_state fips_county: egen vpe_totpopu_white = sum(wa)
	la var vpe_totpopu_white "Total white population, CensusBureau Vintage Population Estimate"
	
	bysort fips_state fips_county: egen vpe_totpopu_black = sum(ba)
	la var vpe_totpopu_black "Total black population, CensusBureau Vintage Population Estimate"
	
	* average age
	gen _midage = .
	replace _midage = 2 if agegrp == 1 // 0-4
	replace _midage = 7 if agegrp == 2 // 5-9
	replace _midage = 12 if agegrp == 3 // 10-14
	replace _midage = 17 if agegrp == 4 // 15-19
	replace _midage = 22 if agegrp == 5 // 20-24
	replace _midage = 27 if agegrp == 6 // 25-29
	replace _midage = 32 if agegrp == 7 // 30-34
	replace _midage = 37 if agegrp == 8 // 35-39
	replace _midage = 42 if agegrp == 9 // 40-44
	replace _midage = 47 if agegrp == 10 // 45-49
	replace _midage = 52 if agegrp == 11 // 50-54
	replace _midage = 57 if agegrp == 12 // 55-59
	replace _midage = 62 if agegrp == 13 // 60-64
	replace _midage = 67 if agegrp == 14 // 65-69
	replace _midage = 72 if agegrp == 15 // 70-74
	replace _midage = 77 if agegrp == 16 // 75-79
	replace _midage = 82 if agegrp == 17 // 80-84
	replace _midage = 87 if agegrp == 18 // >=85
	bysort fips_state fips_county: egen vpe_avgage = wtmean(_midage), weight(tot_pop)
	la var vpe_avgage "Average age, CensusBureau Vintage Population Estimate"
	
	* population of working age
	bysort fips_state fips_county: egen vpe_totpopu_work = sum(tot_pop) if agegrp > 3 & agegrp < 15
	la var vpe_totpopu_work "Total working age population from age 15-70, CensusBureau Vintage Population Estimate"
	
	* slim
	keep fips_* year vpe_*
	drop if missing(vpe_totpopu_work)
	duplicates drop
	
	* save
	save "output/raw`t'.dta", replace
	
	
}

* APPEND
{
	clear
	forvalues t = 2003/2019 {
		append using "output/raw`t'.dta"
	}
	* type conversion of fips code
	gen int _s = floor(fips_state)
	gen int _c = floor(fips_county)
	drop fips_state fips_county
	rename _s fips_state
	rename _c fips_county
	gen long fips = floor(fips_state * 1000 + fips_county)
	
	save "output/vpe.dta"
}