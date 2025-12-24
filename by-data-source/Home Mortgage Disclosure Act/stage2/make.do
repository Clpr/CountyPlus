* MERGE CLEANED HMDA YEARLY DATA

version 15

clear
forvalues t = 2003/2019 {
	append using "original/raw`t'.dta"
}

capture : drop index
capture : destring fips_state, replace force
capture : destring fips_county, replace force
gen long fips = floor(fips_state * 1000 + fips_county)
drop if missing(fips)


* labelling
la var hmda_totnum_complete "Total completed transactions, HMDA"
la var hmda_totnum_approval "Total approved transactions, HMDA"
la var hmda_totnum_denial "Total denial transactions, HMDA"
la var hmda_totnum_sex_male "Total male applicants, HMDA"
la var hmda_totnum_sex_female "Total female applicants, HMDA"
la var hmda_totnum_race_white "Total white applicants, HMDA"
la var hmda_totnum_race_black "Total black applicants, HMDA"
la var hmda_totnum_race_asian "Total asian applicants, HMDA"
la var hmda_totnum_denial_collateral "Total denial due to lack of collateral, HMDA"
la var hmda_totnum_denial_d2incratio "Total denial due to debt-income ratio, HMDA"
la var hmda_totnum_denial_credithist "Total denial due to credit history, HMDA"
la var hmda_totnum_denial_insuffcash "Total denial due to insufficient cash, HMDA"
la var hmda_ratespread_pct_mean "Mortgage spread in pct - Mean, HMDA"
la var hmda_ratespread_pct_count "Mortgage spread in pct - Count of data points, HMDA"
la var hmda_ratespread_pct_median "Mortgage spread in pct - Median, HMDA"
la var hmda_ratespread_pct_var "Mortgage spread in pct - Variance, HMDA"


save "hmda.dta", replace




