/*******************************************************************************
2004 LAR DATA

----------
NOTES:

- data dictionary: `233.1-24ADL.pdf`, `lar_record_codes.pdf`
*******************************************************************************/

/* DATA READING ***************************************************************/
{
	local RAWPATH = "${RAWDATA_FOLDER}/HMDA 02-06 ultimate LAR/2004 LAR"
	local ZIPFILE = "u2004lar.public.dat.zip"
	local UNZIPED = "u2004lar.public.dat"
	
	unzipfile "`RAWPATH'/`ZIPFILE'", replace
	
	qui infix ///
		int   year                  1-4    /// 1
		str10 id                    5-14   ///
		str1  agency_code           15-15  ///
		str1  loan_type             16-16  ///
		str1  loan_purpose          17-17  /// 5
		str1  occupancy             18-18  ///
		str5  loan_amount           19-23  ///
		str1  action_taken          24-24  ///
		str4  property_msa          25-29  ///
		str2  state_code            30-31  /// 10
		str3  county_code           32-34  ///
		str7  census_tract_number   35-41  ///
		str1  sex                   42-42  /// 
		str1  sex_coapplicant       43-43  ///
		str4  income                44-47  /// 15
		str1  type_purchaser        48-48  ///
		str1  denial_reason1        49-49  ///
		str1  denial_reason2        50-50  /// 
		str1  denial_reason3        51-51  ///
		str1  edit_status           52-52  /// 20
		str1  property_type         53-53  ///
		str1  preapprovals          54-54  ///
		str1  ethnicity             55-55  ///
		str1  ethnicity_coapplicant 56-56  ///
		str1  race1                 57-57  ///
		str1  race2                 58-58  ///
		str1  race3                 59-59  ///
		str1  race4                 60-60  ///
		str1  race5                 61-61  ///
		str1  race1_coapplicant     62-62  ///
		str1  race2_coapplicant     63-63  ///
		str1  race3_coapplicant     64-64  ///
		str1  race4_coapplicant     65-65  ///
		str1  race5_coapplicant     66-66  ///
		str5  rate_spread           67-71  ///
		str1  hoepa_status          72-72  ///
		str1  lien_status           73-73  ///
		int   sequence_number       74-80  ///
	using "`UNZIPED'", clear
	
	capture : erase "`UNZIPED'"
	
	di "Data imported"
}
/* VARIABLE LABELLING *********************************************************/
{
    la var year                  "year of data (i.e. 1990)"
    la var id                    "respondent ID, unique within agency"
    la var agency_code           "agency code; B,C,D,E,X = State exempts"
    la var loan_type             "loan type; conventional = any other than FHA,VA,FSA,OHS loans"
    la var loan_purpose          "loan purpose"
    la var occupancy             "occupancy"
    la var loan_amount           "amount of loan (thousand dollars)"
    la var action_taken          "type of action taken"
    la var property_msa          "MSA of property"
    la var state_code            "state code (FIPS, 2 digits)"
    la var county_code           "county code (within-state FIPS, 3 digits)"
    la var census_tract_number   "Census tract number"
    la var sex                   "applicant sex"
    la var sex_coapplicant       "co-applicant sex"
    la var income                "applicant income (thousand dollars)"
    la var type_purchaser        "type of purchaser"
    la var denial_reason1        "denial reason 1"
    la var denial_reason2        "denial reason 2"
    la var denial_reason3        "denial reason 3"
    la var edit_status           "edit status (blank = no edit failures)"
	la var property_type         "property type"
	la var preapprovals          "preapproval status"
	la var ethnicity             "ethnicity of applicant"
	la var ethnicity_coapplicant "ethnicity of co-applicant"
	la var race1                 "applicant race 1"
	la var race2                 "applicant race 2"
	la var race3                 "applicant race 3"
	la var race4                 "applicant race 4"
	la var race5                 "applicant race 5"
	la var race1_coapplicant     "co-applicant race 1"
	la var race2_coapplicant     "co-applicant race 2"
	la var race3_coapplicant     "co-applicant race 3"
	la var race4_coapplicant     "co-applicant race 4"
	la var race5_coapplicant     "co-applicant race 5"
	la var rate_spread           "morgage rate spread in percentage points"
	la var hoepa_status          "if it is a Home Ownership and Equity Protection Act (HOEPA) loan, only for loans originated or purchased"
	la var lien_status           "lien status, only for applications and originations"
    la var sequence_number       "sequence number (a one-up nbr within a reporter, to make each record unique)"
}
/* VALUE LABELING *************************************************************/
{
	// -------------------------------------------------------------------------
	la define vlab_agency_code ///
		1 "OCC"  ///
		2 "FRS"  ///
		3 "FDIC" ///
		4 "OTS"  ///
		5 "NCUA" ///
		7 "HUD"  ///
	, replace
	capture : destring agency_code, replace force
	label values agency_code vlab_agency_code
	// -------------------------------------------------------------------------
	la define vlab_loan_type ///
		1 "Conventional"                                 ///
		2 "FHA-insured (Federal Housing Administration)" ///
		3 "VA-guaranteed (Veterans Administration)"      ///
		4 "FSA/RHS (Farm Service Agency or Rural Housing Service)" ///
	, replace
	capture : destring loan_type, replace force
	label values loan_type vlab_loan_type
	// -------------------------------------------------------------------------
	la define vlab_loan_purpose ///
		1 "Home purchase"    ///
		2 "Home improvement" ///
		3 "Refinancing"      ///
	, replace
	capture : destring loan_purpose, replace force
	label values loan_purpose vlab_loan_purpose
	// -------------------------------------------------------------------------
	la define vlab_occupancy ///
		1 "Owner-occupied as a principal dwelling" ///
		2 "Not owner-occupied"                     ///
		3 "Not applicable"                         ///
	, replace
	capture : destring occupancy, replace force
	label values occupancy vlab_occupancy
	// -------------------------------------------------------------------------
	capture : destring loan_amount, replace force
	// -------------------------------------------------------------------------
	la define vlab_action_taken ///
		1 "Loan originated"                                     ///
		2 "Application approved but not accepted"               ///
		3 "Application denied by financial institution"         ///
		4 "Application withdrawn by applicant"                  ///
		5 "File closed for incompleteness"                      ///
		6 "Loan purchased by the institution"                   ///
		7 "Preapproval request denied by financial institution" ///
		8 "Preapproval request approved but not accepted (optional reporting)" ///
	, replace
	capture : destring action_taken, replace force
	label values action_taken vlab_action_taken
	// -------------------------------------------------------------------------
	* define: full FIPS
	capture : gen fips = state_code + county_code
	// -------------------------------------------------------------------------
	la define vlab_sex ///
		1 "Male"                     ///
		2 "Female"                   ///
		3 "Information not provided" ///
		4 "Not applicable"           ///
		5 "No co-applicant"          ///
	, replace
	capture : destring sex, replace force
	capture : destring sex_coapplicant, replace force
	la values sex vlab_sex
	la values sex_coapplicant vlab_sex
	// -------------------------------------------------------------------------
	capture : destring income, replace force
	// -------------------------------------------------------------------------
	la define vlab_type_purchaser ///
		0 "Loan was not originated or was not sold in calendar year covered by register" ///
		1 "Fannie Mae (FNMA)" ///
		2 "Ginnie Mae (GNMA)" ///
		3 "Freddie Mac (FHLMC)" ///
		4 "Farmer Mac (FAMC)"   ///
		5 "Private securitization" ///
		6 "Commercial bank, savings bank or savings association" ///
		7 "Life insurance company, credit union, mortgage bank, or finance company" ///
		8 "Affiliate institution" ///
		9 "Other type of purchaser" ///
	, replace
	capture : destring type_purchaser, replace force
	la values type_purchaser vlab_type_purchaser
	// -------------------------------------------------------------------------
	la define vlab_denial_reason  ///
		1 "Debt-to-income ratio"  ///
		2 "Employment history"    ///
		3 "Credit history"        ///
		4 "Collateral"            ///
		5 "Insufficient cash (downpayment, closing costs)" ///
		6 "Unverifiable information"      ///
		7 "Credit application incomplete" ///
		8 "Mortgage insurance denied"     ///
		9 "Other"                         ///
	, replace
	foreach i in 1 2 3 {
		capture : destring denial_reason`i', replace force
		la values denial_reason`i' vlab_denial_reason
	}
	// -------------------------------------------------------------------------
	la define vlab_edit_status ///
		5 "Validity edit failure only" ///
		6 "Quality edit failure only"  ///
		7 "Validity and quality edit failures" ///
	, replace
	capture : destring edit_status, force replace
	la values edit_status vlab_edit_status
	// -------------------------------------------------------------------------
	la define vlab_property_type ///
		1 "One to four-family (other than manufactured housing)" ///
		2 "Manufactured housing" ///
		3 "Multifamily"          ///
	, replace
	capture : destring property_type, replace force
	la values property_type vlab_property_type
	// -------------------------------------------------------------------------
	la define vlab_preapprovals ///
		1 "Preapproval was requested"     ///
		2 "Preapproval was NOT requested" ///
		3 "Not applicable"                ///
	, replace
	capture : destring preapprovals, replace force
	la values preapprovals vlab_preapprovals
	// -------------------------------------------------------------------------
	la define vlab_ethnicity ///
		1 "Hispanic or Latino"       ///
		2 "Not Hispanic or Latino"   ///
		3 "Information not provided" ///
		4 "Not applicable"           ///
		5 "No co-applicant"          ///
	, replace
	capture : destring ethnicity, replace force
	capture : destring ethnicity_coapplicant, replace force
	la values ethnicity vlab_ethnicity
	la values ethnicity_coapplicant vlab_ethnicity
	// -------------------------------------------------------------------------
	la define vlab_race ///
		1 "American Indian or Alaska Native"          ///
		2 "Asian"                                     ///
		3 "Black or African American"                 ///
		4 "Native Hawaiian or Other Pacific Islander" ///
		5 "White"                                     ///
		6 "Information not provided"                  ///
		7 "Not applicable"                            ///
		8 "No co-applicant"                           ///
	, replace
	foreach i of numlist 1/5 {
		capture : destring race`i', replace force
		capture : destring race`i'_coapplicant, replace force
		label values race`i' vlab_race
		label values race`i'_coapplicant vlab_race
	}
	// -------------------------------------------------------------------------
	capture : destring rate_spread, replace force
	// -------------------------------------------------------------------------
	la define vlab_hoepa_status ///
		1 "HOEPA loan" ///
		2 "Not a HOEPA loan" ///
	, replace
	capture : destring hoepa_status, replace force
	la values hoepa_status vlab_hoepa_status
	// -------------------------------------------------------------------------
	la define vlab_lien_status ///
		1 "Secured by a first lien"          ///
		2 "Secured by a subordinate lien"    ///
		3 "Not secured by a lien"            ///
		4 "Not applicbale (purchased loans)" ///
	, replace
	capture : destring lien_status, replace force
	la values lien_status vlab_lien_status
	
}

/* SAVE ***********************************************************************/
save "${OUTPUT_FOLDER}/raw2004.dta", replace





/* AGGREGATION ****************************************************************/
{

	use "${OUTPUT_FOLDER}/raw2004.dta", clear

	/*------------------------------
	TECH NOTES
	
	- the availability and validity of race, sex and other demographic or 
	  background information do NOT filter/exclude observations. Only loan
	  purpose, loan amount and action taken matter.
	  
	- if multiple denial reasons recorded, then any of them matched is seen as 
	  being matched.
	  
	- since 2004, race changed a lot cp. 2002-03. our rule: as long as a race
	  type (e.g. white) is claimed in any of the 5 race variables, then the
	  applicant/loan gets a point. No co-applicant is considered, that is not
	  what we care in this study.
	  
	- mortgage rate spread has a vast of missing values. we record its stats
	  and must record its valid sample size.
	
	------------------------------*/
	
	* STEP: filter obs
	{
		* filter: first-lien, 1-4 family loans
		keep if lien_status == 1
		
		* filter: no home improvement (Mian-Sufi's practice)
		drop if loan_purpose == 2
		
		* filter: no loan amount recorded
		drop if missing(loan_amount)
		
		* filter: only purchase loan, no second market transactions
		* filter: only completed loan transactions
		drop if inlist(action_taken, 4, 5, 6)
		drop if missing(action_taken)
	}
	
	* STEP: unify indices
	{
		destring state_code, gen(fips_state) force
		destring county_code, gen(fips_county) force
		drop if missing(fips_state) | missing(fips_county)
		
		la var fips_state "FIPS code of state"
		la var fips_county "FIPS code of county (3-digit, within state)"
		la var fips "5-digit county FIPS code"
	}
	
	
	* STEP: aggregation, by action taken
	{
		* flags (will be reused later, so no GC)
		gen flag_approval = inlist(action_taken, 1, 2, 8)
		gen flag_denial = inlist(action_taken, 3, 7)
		
		* total (completed)
		bysort fips_state fips_county: gen hmda_totnum_complete = _N
		
		* approved (regardless accepted or not; including preapproval)
		bysort fips_state fips_county: egen hmda_totnum_approval = sum(flag_approval)
		
		* denied
		bysort fips_state fips_county: egen hmda_totnum_denial = sum(flag_denial)
		
		
		la var hmda_totnum_complete "HMDA #loans : completed cases"
		la var hmda_totnum_approval "HMDA #loans : approved cases"
		la var hmda_totnum_denial   "HMDA #loans : denied cases"
	}
	
	* STEP: aggregation, loan amount
	{
		replace loan_amount = 1 if loan_amount == 0  // observation: rare, so ok
		
		* loan amount: all loans (completed)
		// NOTES: a kept county must have at least one obs, so mean is well defined
		bysort fips_state fips_county: egen hmda_lamt_complete_sum = sum(loan_amount)
		bysort fips_state fips_county: gen hmda_lamt_complete_mean = hmda_lamt_complete_sum / _N
		
		* loan amount: approved loans
		// NOTES: some county may have no approved loans, so replace the undefined mean as 0
		bysort fips_state fips_county: egen hmda_lamt_approval_sum = total(cond(flag_approval,loan_amount,0))
		bysort fips_state fips_county: gen hmda_lamt_approval_mean = hmda_lamt_approval_sum / hmda_totnum_approval
		replace hmda_lamt_approval_mean = 0 if missing(hmda_lamt_approval_mean)
		
		* loan amount: denied loans
		// NOTES: the same, some counties may have no denied loans
		bysort fips_state fips_county: egen hmda_lamt_denial_sum = total(cond(flag_denial,loan_amount,0))
		bysort fips_state fips_county: gen hmda_lamt_denial_mean = hmda_lamt_denial_sum / hmda_totnum_denial
		replace hmda_lamt_denial_mean = 0 if missing(hmda_lamt_denial_mean)
		
		
		foreach kw in complete approval denial {
			la var hmda_lamt_`kw'_sum  "HMDA loan amount ($000)  sum: `kw'"
			la var hmda_lamt_`kw'_mean "HMDA loan amount ($000)  mean: `kw'"
		}
	}
	
	* STEP: aggregation, race
	{
		/*----------
		TECH NOTES:
		
		
		----------*/
		
		local PREFIX0 = "hmda_totnum_race"
		local HEAD = "bysort fips_state fips_county: egen "
		
		local RACES = "white black asian"
		local CODES = "5 3 2"
		local NITEM : word count `RACES'
		
		* def: race flags
		forvalues i = 1/`NITEM' {
			local rs : word `i' of `RACES'
			local cs : word `i' of `CODES'
			
			capture : gen flag_race_`rs' = (race1 == `cs') | (race2 == `cs') | (race3 == `cs') | (race4 == `cs') | (race5 == `cs')
			
			* count
			capture : `HEAD' `PREFIX0'_`rs'_complete = sum(flag_race_`rs')
			capture : `HEAD' `PREFIX0'_`rs'_approval = total(cond(flag_approval == 1, flag_race_`rs',0))
			capture : `HEAD' `PREFIX0'_`rs'_denial   = total(cond(flag_denial   == 1, flag_race_`rs',0))			
		}
		
		* def: valid race record flag
		capture : gen flag_race_valid = 0
		forvalues i = 1/5 {
			replace flag_race_valid = 1 if inlist(race`i',1,2,3,4,5)
		}
		
		* count
		capture : `HEAD' `PREFIX0'_valid_complete = sum(flag_race_valid)
		capture : `HEAD' `PREFIX0'_valid_approval = total(cond(flag_approval == 1, flag_race_valid,0))
		capture : `HEAD' `PREFIX0'_valid_denial   = total(cond(flag_denial   == 1, flag_race_valid,0))
		
		* labelling
		foreach kw in white black asian valid {
			foreach sta in complete approval denial {
				la var hmda_totnum_race_`kw'_`sta' "HMDA #loans by race: `kw' : `sta'"
			}
		}
		
	}
	
	* STEP: aggregation, sex
	{
		local PREFIX = "hmda_totnum_sex"
		
		// count: valid/applicable (since there is a large share of not-applicable or info-not-provided records)
		bysort fips_state fips_county: egen `PREFIX'_valid_complete = total(cond(inlist(sex,1,2),1,0))
		bysort fips_state fips_county: egen `PREFIX'_valid_approval = total(cond(inlist(sex,1,2) & (flag_approval == 1),1,0))
		bysort fips_state fips_county: egen `PREFIX'_valid_denial   = total(cond(inlist(sex,1,2) & (flag_denial == 1),1,0))
			
		// count: male
		bysort fips_state fips_county: egen `PREFIX'_male_complete = total(cond(inlist(sex,1),1,0))
		bysort fips_state fips_county: egen `PREFIX'_male_approval = total(cond(inlist(sex,1) & (flag_approval == 1),1,0))
		bysort fips_state fips_county: egen `PREFIX'_male_denial   = total(cond(inlist(sex,1) & (flag_denial == 1),1,0))
		
		// count: female
		bysort fips_state fips_county: egen `PREFIX'_female_complete = total(cond(inlist(sex,2),1,0))
		bysort fips_state fips_county: egen `PREFIX'_female_approval = total(cond(inlist(sex,2) & (flag_approval == 1),1,0))
		bysort fips_state fips_county: egen `PREFIX'_female_denial   = total(cond(inlist(sex,2) & (flag_denial == 1),1,0))
		
		foreach kw in valid male female {
			foreach sta in complete approval denial {
				la var `PREFIX'_`kw'_`sta' "HMDA #loans by sex: `kw' : `sta'"
			}
		}
		
	}
	
	* STEP: income
	{
		local PREFIX = "hmda_inc"
		
		* summation
		bysort fips_state fips_county: egen `PREFIX'_complete_sum = total(cond(!missing(income),income,0))
		bysort fips_state fips_county: egen `PREFIX'_approval_sum = total(cond((!missing(income)) & (flag_approval == 1),income,0))
		bysort fips_state fips_county: egen `PREFIX'_denial_sum = total(cond((!missing(income)) & (flag_denial == 1),income,0))
		
		* mean
		bysort fips_state fips_county: gen `PREFIX'_complete_mean = `PREFIX'_complete_sum / hmda_totnum_complete
		bysort fips_state fips_county: gen `PREFIX'_approval_mean = `PREFIX'_approval_sum / hmda_totnum_approval
		bysort fips_state fips_county: gen `PREFIX'_denial_mean   = `PREFIX'_denial_sum   / hmda_totnum_denial
		
		foreach sta in complete approval denial {
			foreach kw in sum mean {
				la var `PREFIX'_`sta'_`kw' "HMDA income ($000)  `kw': `sta'"
			}
		}
		
	}
	
	* STEP: denial reasons
	{
		
		local PREFIX0 = "flag_denial"
		local PREFIX1 = "hmda_totnum_denial"
		local NAMES = "d2incratio employhist credithist collateral insuffcash unveriinfo appincompl minsdenied otherreaso"
		
		* flags (take union of the multiple reasons)
		local i = 1
		foreach rsn of local NAMES {
			
			gen `PREFIX0'_`rsn' = (denial_reason1 == `i') | (denial_reason2 == `i') | (denial_reason3 == `i')
			
			bysort fips_state fips_county: egen `PREFIX1'_`rsn' = sum(`PREFIX0'_`rsn')
			
			la var `PREFIX1'_`rsn' "HMDA #loans denied due to: `rsn'"
			
			drop `PREFIX0'_`rsn'
			
			local i = `i' + 1
		}
		
	}
	
	* STEP: mortgage rate spread
	{
		
		* count valid sample
		capture : bysort fips_state fips_county: egen hmda_ratespread_pct_N = total(cond(!missing(rate_spread),1,0))
		capture : la var hmda_ratespread_pct_N "HMDA #loans that have mortgage rate spread recorded"
		
		* summarize
		foreach stat in mean median sd {
			
			capture : bysort fips_state fips_county: egen hmda_ratespread_pct_`stat' = `stat'(rate_spread)
			
			la var hmda_ratespread_pct_`stat' "HMDA mortgage rate spread in pct: `stat'"
		}
		
	}

	
} // aggregation




/* SLICE & SAVE ***************************************************************/
{
	keep year fips fips_state fips_county hmda_*
	
	duplicates drop
	
	save "${OUTPUT_FOLDER}/final2004.dta", replace
}





