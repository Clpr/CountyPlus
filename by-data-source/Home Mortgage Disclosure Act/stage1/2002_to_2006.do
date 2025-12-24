/*******************************************************************************
MAIN FLOW

----------
NOTES:

- WE ONLY CONSIDER FIRST-LIEN LOAN, 1-4 FAMILY, WHICH IS STANDARD DATA SAMPLE
	- 02-06: ONLY FULL LAR DATA AVAILABLE, NEED TO CLEAN THEM OURSELVES
	- 07-17: FILTERED FIRST LIEN LOAN DATA ARE AVAILABLE AND DOWNLOADED
	- 18-19: SEPARATELY PROCESSED
- EACH YEAR'S DATA ARE SUMMARIZED IN ITS OWN SCRIPT WITHOUT APPENDING ACROSS
  YEARS. BECAUSE: TOO LARGE FILE; POSSIBLE INCONSISTENT ENCODING ACROSS YEARS.
	
	
	
----------
STATISTICS & CONSTRUCTED VARIABLES:

- year[int]
- fips_state[int]
- fips_county[int]
- nobs_total[int]
- nobs_valid[int]
- hmda_totnum_complete[int]
- hmda_totnum_approval[int]
- hmda_totnum_denial[int]
- hmda_totnum_sex_male[int]
- hmda_totnum_sex_female[int]
- hmda_totnum_race_white[int]
- hmda_totnum_race_black[int]
- hmda_totnum_race_asian[int]
- hmda_totnum_denial_collateral[int]
- hmda_totnum_denial_d2incratio[int]
- hmda_totnum_denial_credithist[int]
- hmda_totnum_denial_insuffcash[int]
- hmda_ratespread_pct_mean[float]
- hmda_ratespread_pct_count[float]
- hmda_ratespread_pct_median[float]
- hmda_ratespread_pct_var[float]

	
----------
DEPENDENCY:
- mdesc
- mipolate
- wtmean (egen)

*******************************************************************************/
clear all
mata: mata clear

global RAWDATA_FOLDER = "../HMDA data - raw/"
global RAWDATA_FOLDER_0206 = "../HMDA data - raw/HMDA 02-06 ultimate LAR/"
global RAWDATA_FOLDER_0717 = "../HMDA data - raw/HMDA 07-17 FirstLien/07-17 Showing nationwide records"

global OUTPUT_FOLDER  = "output/"



/*==============================================================================
STAGE: 2002 - 2006

----------
NOTES:

- All records LAR data; needs filter
- Stages are divided by variable categories and what data were collected.
==============================================================================*/

* stage: 2002-2003
do "0206ch1_2002.do"
do "0206ch1_2003.do"

* stage: 2004-2006
do "0206ch1_2004.do"
do "0206ch1_2005.do"
do "0206ch1_2006.do"

* GC
forvalues t = 2002/2006 {
	capture : erase "output/raw`t'.dta"
}


/*==============================================================================
STAGE: 2007 - 2019

----------
NOTES:

- This chapter takes VERY VERY LONG LONG time!
- Stages are divided by variable categories and what data were collected.
==============================================================================*/

* check Julia scripts







/*==============================================================================
APPENDING, MERGING, AND POST-PROCESSING

----------
NOTES:
==============================================================================*/

* step: destring FIPS for 02-06 (legacy reason, I dont want to re-run everything	
forvalues t = 2002/2006 {
	use "output/final`t'.dta", clear
	capture : destring fips, force replace
	save "output/final`t'.dta", replace
}

* step: appending all years data
clear
forvalues t = 2002/2019 {
	append using "output/final`t'.dta", force
}

* step: post-process cleaning
drop if fips < 1001

* step: check missings
mdesc hmda_totnum_denial hmda_totnum_denial_*


* step: save
save "output/hmda0219.dta", replace


