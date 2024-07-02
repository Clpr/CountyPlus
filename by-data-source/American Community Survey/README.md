# README - American Community Survey (ACS)

## I. Pipeline

* **Input**: ACS 1 year and 5 year estimates
    * `ACSDP5Y2019.DP04-Data.csv`
    * `ACSDP1Y2019.DP04-Data`
* **Processing files**:
    * `make_mhv19.do`
* **Output**: 
    * `mhv19.dta`
* **Variables**
    * `mhv19_5y`: 2019 Median house value, dollar, ACS 5-year estimates
    * `fips`: 5-digit county FIPS
    * `fips_state`: State FIPS
    * `fips_county`: 3-digit county FIPS
    * `mhv19_1y`: 2019 Median house value, dollar, ACS 1-year estimates
    * `mhv19`: 2019 Median house value, dollar, ACS 5-year and 1-year estimates

## II. Data download

* Go to `data.census.gov`
* Set filters:
    * Years = (a specific year to download)
    * Topics = Housing --> Financial Characteristics --> Select Financial Characteristics --> Housing Value and Purchase Price
    * Surveys = ACS --> ACS 1-year/5-year Estimates --> Data Profiles
    * Geography = All Counties within US and Puerto Rico
* Then, download the data of zip files. The downloaded files are named in fashion `ACSDPxY2019.DP04_yyyy-mm-ddThhmmss.zip`, where `x` is one of 1 or 5 meaning 1-year or 5-year estimates.
* The 5-year estimates covers all 3000+ counties, while 1-year estimates only covers 800+ counties. We need both

## III. Data processing

* Construct FIPS code for merging with `id.dta`
* For missing `mhv19` observations, use state average to fill it.