/*******************************************************************************
2007 LAR DATA

----------
NOTES:

- data dictionary: `lar_record_codes.pdf`
*******************************************************************************/

/* DATA READING ***************************************************************/
{
	local RAWPATH = "${RAWDATA_FOLDER}/HMDA 07-17 FirstLien/07-17 Showing nationwide records/"
	local ZIPFILE = "hmda_2007_nationwide_first-lien-owner-occupied-1-4-family-records_labels.zip"
	local UNZIPED = "hmda_2007_nationwide_first-lien-owner-occupied-1-4-family-records_labels.csv"
	
	unzipfile "`RAWPATH'/`ZIPFILE'", replace
	
	import delimited using "`UNZIPED'" ///
		, clear delim(",") varnames(1) case(lower)
	
	capture : erase "`UNZIPED'"
	
	di "Data imported"
}
/* VARIABLE RENAMING **********************************************************/
{
	rename as_of_year year
	rename respondent_id id
	// no change: agency_name
	// no change: agency_abbr
	// no change: agency_code
	// no change: loan_type_name
	// no change: loan_type
	// no change: property_type_name
	// no change: property_type
	// no change: loan_purpose_name
	// no change: loan_purpose
	rename owner_occupancy_name occupancy_name
	rename owner_occupancy occupancy
	rename loan_amount_000s loan_amount
	rename preapproval_name preapprovals_name
	rename preapproval preapprovals
	// no change: action_taken_name
	// no change: action_taken
	rename msamd_name property_msa_name
	rename msamd property_msa
	// no change: state_name
	// no change: state_abbr
	// no change: state_code
	// no change: county_name
	// no change: county_code
	// no change: census_tract_number
	rename applicant_ethnicity_name ethnicity_name
	rename applicant_ethnicity ethnicity
	rename co_applicant_ethnicity_name ethnicity_coapplicant_name
	rename co_applicant_ethnicity ethnicity_coapplicant
	rename applicant_race_name_1 race1_name
	rename applicant_race_1 race1
	rename applicant_race_name_2 race2_name
	rename applicant_race_2 race2
	rename applicant_race_name_3 race3_name
	rename applicant_race_3 race3
	rename applicant_race_name_4 race4_name
	rename applicant_race_4 race4
	rename applicant_race_name_5 race5_name
	rename applicant_race_5 race5
	rename co_applicant_race_name_1 race1_coapplicant_name
	rename co_applicant_race_1 race1_coapplicant
	rename co_applicant_race_name_2 race2_coapplicant_name
	rename co_applicant_race_2 race2_coapplicant
	rename co_applicant_race_name_3 race3_coapplicant_name
	rename co_applicant_race_3 race3_coapplicant
	rename co_applicant_race_name_4 race4_coapplicant_name
	rename co_applicant_race_4 race4_coapplicant
	rename co_applicant_race_name_5 race5_coapplicant_name
	rename co_applicant_race_5 race5_coapplicant
	rename applicant_sex_name sex_name
	rename applicant_sex sex
	rename co_applicant_sex_name sex_coapplicant_name
	rename co_applicant_sex sex_coapplicant
	rename applicant_income_000s income
	rename purchaser_type_name type_purchase_name
	rename purchaser_type type_purchaser
	rename denial_reason_name_1 denial_reason1_name
	rename denial_reason_1 denial_reason1
	rename denial_reason_name_2 denial_reason2_name
	rename denial_reason_2 denial_reason2
	rename denial_reason_name_3 denial_reason3_name
	rename denial_reason_3 denial_reason3
	// no change: rate_spread
	// no change: hoepa_status_name
	// no change: hoepa_status
	// no change: lien_status_name
	// no change: lien_status
	// no change: edit_status_name
	// no change: edit_status
	// no change: sequence_number
	// no change: population
	// no change: minority_population
	// no change: hud_median_family_income
	// no change: tract_to_msamd_income
	// no change: number_of_owner_occupied_units
	// no change: number_of_1_to_4_family_units
	// no change: application_date_indicator
}
/* VARIABLE LABELLING *********************************************************/
{
    la var year "year of data (i.e. 1990)"
	la var id "respondent ID, unique within agency"
	la var agency_name "agency name"
	la var agency_abbr "agency abbreviation"
	la var agency_code "agency code; B,C,D,E,X = State exempts"
	la var loan_type_name "loan type name"
	la var loan_type "loan type; conventional = any other than FHA,VA,FSA,OHS loans"
	la var property_type_name "property type name"
	la var property_type "property type"
	la var loan_purpose_name "loan purpose name"
	la var loan_purpose "loan purpose"
	la var occupancy_name "occupancy name"
	la var occupancy "occupancy"
	la var loan_amount "amount of loan (thousand dollars)"
	la var preapprovals_name "preapprovals status name"
	la var preapprovals "preapproval status"
	la var action_taken_name "name: type of action taken"
	la var action_taken "type of action taken"
	la var property_msa_name "name: MSA of property"
	la var property_msa "MSA of property"
	la var state_name "state name"
	la var state_abbr "state abbreviation"
	la var state_code "state code (FIPS, 2 digits)"
	la var county_name "county name"
	la var county_code "county code (within-state FIPS, 3 digits)"
	la var census_tract_number "Census tract number"
	la var ethnicity_name "name: ethnicity of applicant"
	la var ethnicity "ethnicity of applicant"
	la var ethnicity_coapplicant_name "name: ethnicity of co-applicatn"
	la var ethnicity_coapplicant "ethnicity of co-applicant"
	la var race1_name "name: applicant race 1"
	la var race1 "applicant race 1"
	la var race2_name "name: applicant race 2"
	la var race2 "applicant race 2"
	la var race3_name "name: applicant race 3"
	la var race3 "applicant race 3"
	la var race4_name "name: applicant race 4"
	la var race4 "applicant race 4"
	la var race5_name "name: applicant race 5"
	la var race5 "applicant race 5"
	la var race1_coapplicant_name "name: co-applicant race 1"
	la var race1_coapplicant "co-applicant race 1"
	la var race2_coapplicant_name "name: co-applicant race 2"
	la var race2_coapplicant "co-applicant race 2"
	la var race3_coapplicant_name "name: co-applicant race 3"
	la var race3_coapplicant "co-applicant race 3"
	la var race4_coapplicant_name "name: co-applicant race 4"
	la var race4_coapplicant "co-applicant race 4"
	la var race5_coapplicant_name "name: co-applicant race 5"
	la var race5_coapplicant "co-applicant race 5"
	la var sex_name "name: applicant sex"
	la var sex "applicant sex"
	la var sex_coapplicant_name "name: co-applicant sex"
	la var sex_coapplicant "co-applicant sex"
	la var income "applicant income (thousand dollars)"
	la var type_purchase_name "name: type of purchaser"
	la var type_purchaser "type of purchaser"
	la var denial_reason1_name "name: denial reason 1"
	la var denial_reason1 "denial reason 1"
	la var denial_reason2_name "name: denial reason 2"
	la var denial_reason2 "denial reason 2"
	la var denial_reason3_name "name: denial reason 3"
	la var denial_reason3 "denial reason 3"
	la var rate_spread "morgage rate spread in percentage points"
	la var hoepa_status_name "name: HOEPA status"
	la var hoepa_status "if it is a Home Ownership and Equity Protection Act (HOEPA) loan, only for loans originated or purchased"
	la var lien_status_name "name: lien status"
	la var lien_status "lien status, only for applications and originations"
	la var edit_status_name "name: edit status"
	la var edit_status "edit status (blank = no edit failures)"
	la var sequence_number "sequence number (a one-up nbr within a reporter, to make each record unique)"
	la var population "total population in tract"
	la var minority_population "percentage of minority population to total population for tract"
	la var hud_median_family_income "FFIEC Median family income in dollars for the MSA/MD in which the tract is located (adjusted annually by FFIEC)"
	la var tract_to_msamd_income "% of tract median family income compared to MSA/MD median family income"
	la var number_of_owner_occupied_units "Number of dwellings, including individual condominiums, that are lived in by the owner"
	la var number_of_1_to_4_family_units "Dwellings that are built to house fewer than 5 families"
	la var application_date_indicator "indicator for application date"
}
/* SAVE ***********************************************************************/
save "${OUTPUT_FOLDER}/raw2007.dta", replace








/* AGGREGATION ****************************************************************/
{

	use "${OUTPUT_FOLDER}/raw2007.dta", clear

	/*------------------------------
	TECH NOTES
	
	- the same as before-2007
	
	- 
	
	------------------------------*/
	
	* STEP: filter obs
	{
		* filter: first-lien, 1-4 family loans
		// skipped. as we directly use downloaded first-lien data
		
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
	


