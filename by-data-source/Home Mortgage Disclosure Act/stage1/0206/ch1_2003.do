/*******************************************************************************
2003 LAR DATA

----------
NOTES:

- data dictionary: `233.1-24ADL.pdf`, `lar_record_codes.pdf`
*******************************************************************************/

/* DATA READING ***************************************************************/
{
	local RAWPATH = "${RAWDATA_FOLDER}/HMDA 02-06 ultimate LAR/2003 LAR"
	local ZIPFILE = "HMS.U2003.LARS.zip"
	local UNZIPED = "HMS.U2003.LARS"
	
	unzipfile "`RAWPATH'/`ZIPFILE'", replace
	
	qui infix ///
		int   year                1-4    /// 1
		str10 id                  5-14   ///
		str1  agency_code         15-15  ///
		str1  loan_type           16-16  ///
		str1  loan_purpose        17-17  /// 5
		str1  occupancy           18-18  ///
		str5  loan_amount         19-23  ///
		str1  action_taken        24-24  ///
		str4  property_msa        25-28  ///
		str2  state_code          29-30  /// 10
		str3  county_code         31-33  ///
		str7  census_tract_number 34-40  ///
		str1  race                41-41  ///
		str1  race_coapplicant    42-42  ///
		str1  sex                 43-43  /// 15
		str1  sex_coapplicant     44-44  ///
		str4  income              45-48  ///
		str1  type_purchaser      49-49  ///
		str1  denial_reason1      50-50  ///
		str1  denial_reason2      51-51  /// 20
		str1  denial_reason3      52-52  ///
		str1  edit_status         53-53  ///
		int   sequence_number     54-60  ///
	using "`UNZIPED'", clear
	
	capture : erase "`UNZIPED'"
	
	di "Data imported"
}
/* VARIABLE LABELLING *********************************************************/
{
    la var year                "year of data (i.e. 1990)"
    la var id                  "respondent ID, unique within agency"
    la var agency_code         "agency code; B,C,D,E,X = State exempts"
    la var loan_type           "loan type; conventional = any other than FHA,VA,FSA,OHS loans"
    la var loan_purpose        "loan purpose"
    la var occupancy           "occupancy"
    la var loan_amount         "amount of loan (thousand dollars)"
    la var action_taken        "type of action taken"
    la var property_msa        "MSA of property"
    la var state_code          "state code (FIPS, 2 digits)"
    la var county_code         "county code (within-state FIPS, 3 digits)"
    la var census_tract_number "Census tract number"
    la var race                "applicant race"
    la var race_coapplicant    "co-applicant race"
    la var sex                 "applicant sex"
    la var sex_coapplicant     "co-applicant sex"
    la var income              "applicant income (thousand dollars)"
    la var type_purchaser      "type of purchaser"
    la var denial_reason1      "denial reason 1"
    la var denial_reason2      "denial reason 2"
    la var denial_reason3      "denial reason 3"
    la var edit_status         "edit status (blank = no edit failures)"
    la var sequence_number     "sequence number (a one-up nbr within a reporter, to make each record unique)"
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
	capture : destring race, replace force
	capture : destring race_coapplicant, replace force
	label values race vlab_race
	label values race_coapplicant vlab_race
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
	destring income, replace force
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
	destring edit_status, force replace
	la values edit_status vlab_edit_status
}

/* SAVE ***********************************************************************/
save "${OUTPUT_FOLDER}/raw2003.dta", replace



/* AGGREGATION ****************************************************************/
{

	use "${OUTPUT_FOLDER}/raw2003.dta", clear

	/*------------------------------
	TECH NOTES
	
	- the availability and validity of race, sex and other demographic or 
	  background information do NOT filter/exclude observations. Only loan
	  purpose, loan amount and action taken matter.
	  
	- if multiple denial reasons recorded, then any of them matched is seen as 
	  being matched.
	
	------------------------------*/
	
	* STEP: filter obs
	{
		* filter: first-lien, 1-4 family loans
		// impossible for 2002-2003, as lien status had not been recorded
		
		* filter: exclude home improvement (Mian Sufi's practice)
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
		* count: white
		bysort fips_state fips_county: egen hmda_totnum_race_white_complete = total(cond(race == 5,1,0))
		bysort fips_state fips_county: egen hmda_totnum_race_white_approval = total(cond((race == 5) & (flag_approval == 1),1,0))
		bysort fips_state fips_county: egen hmda_totnum_race_white_denial   = total(cond((race == 5) & (flag_denial == 1),1,0))
		
		* count: black
		bysort fips_state fips_county: egen hmda_totnum_race_black_complete = total(cond(race == 3,1,0))
		bysort fips_state fips_county: egen hmda_totnum_race_black_approval = total(cond((race == 3) & (flag_approval == 1),1,0))
		bysort fips_state fips_county: egen hmda_totnum_race_black_denial   = total(cond((race == 3) & (flag_denial == 1),1,0))
		
		* count: asian
		bysort fips_state fips_county: egen hmda_totnum_race_asian_complete = total(cond(race == 2,1,0))
		bysort fips_state fips_county: egen hmda_totnum_race_asian_approval = total(cond((race == 2) & (flag_approval == 1),1,0))
		bysort fips_state fips_county: egen hmda_totnum_race_asian_denial   = total(cond((race == 2) & (flag_denial == 1),1,0))
		
		* count: valid/applicable (since there is a large share of not-applicable records)
		bysort fips_state fips_county: egen hmda_totnum_race_valid_complete = total(cond(inlist(race,1,2,3,4,5),1,0))
		bysort fips_state fips_county: egen hmda_totnum_race_valid_approval = total(cond(inlist(race,1,2,3,4,5) & (flag_approval == 1),1,0))
		bysort fips_state fips_county: egen hmda_totnum_race_valid_denial   = total(cond(inlist(race,1,2,3,4,5) & (flag_denial == 1),1,0))
		
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
	
	* STEP: mortgage rate spread (placeholders for early year data only)
	{
		
		foreach stat in mean count median sd {
			gen hmda_ratespread_pct_`stat' = .
			
			la var hmda_ratespread_pct_`stat' "HMDA mortgage rate spread in pct: `stat'"
		}
		
	}

	
} // aggregation




/* SLICE & SAVE ***************************************************************/
{
	keep year fips fips_state fips_county hmda_*
	
	duplicates drop
	
	save "${OUTPUT_FOLDER}/final2003.dta", replace
}
