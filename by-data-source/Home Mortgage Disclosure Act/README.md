# README - Home Mortgage Disclosure Act (HMDA)

**Note**: There are two stages of processing the HMDA data:

- Stage 1: cleaning the original transaction-level data to county-year level data
- Stage 2: Appending these years

We focus on Stage 1. Check `stage2/` folder for Stage 2 documentation.

> Until Sep 28, 2024: The python scripts that process the HMDA data are still under refactoring.

## I. Pipeline

* **Input**:
    * CPI by-year txt-format data files
    * Mian & Sufi (2014) industry classification (cleaned and saved in `../Mian Sufi 2014 Tradability/ms14sector.csv`)
* **Processing files**:
    * `make.do`: main cleaning
    * `fwcp.py`: construct FWCP (fraction of nominal wage cut prevented) friction indicator, the measure of downward nominal wage rigidity (DNWR)
* **Output**: 
    * `rawYYYY.dta`: county level aggregates
    
* **Variables**
    * `rawYYYY.dta`
        * `fips`: County 5-digit FIPS code
        * `year`
        * `fips_county`
        * `fips_state`
        * `hmda_totnum_complete`: Total number of completed cases (in a county)
        * `hmda_totnum_approval`: Total number of approved cases
        * `hmda_totnum_denial`: Total number of denied cases
        * `hmda_totnum_sex_male`: Total number of male applicants
        * `hmda_totnum_sex_female`: Total number of female applicants
        * `hmda_totnum_race_white`: Total number of white applicants
        * `hmda_totnum_race_black`: Total number of black applicants
        * `hmda_totnum_race_asian`: Total number of Asian applicants
        * `hmda_totnum_denial_collateral`: Total number of denied cases due to lack of collateral
        * `hmda_totnum_denial_d2incratio`: Total number of denied cases due to too-high debt-income ratio
        * `hmda_totnum_denial_credithist`: Total number of denied cases due to bad credit history
        * `hmda_totnum_denial_insuffcash`: Total number of denied cases due to insufficient cash
        * `hmda_ratespread_pct_mean`: Mortgage rate spread, mean
        * `hmda_ratespread_pct_count`: Mortgage rate spread, total available observations
        * `hmda_ratespread_pct_median`: Mortgage rate spread, median
        * `hmda_ratespread_pct_var`: Mortgage rate spread, variance

## II. Data download

* **2007-2017**: source: [Home Mortgage Disclosure Act (HMDA) Data | Consumer Financial Protection Bureau (consumerfinance.gov)](https://www.consumerfinance.gov/data-research/hmda/)
    * Set `Geographic area` to `Nationwide`
    * Set `All records`
    * Set `Plain language labels and HMDA codes`

<img src="data%20source%201.png" alt="data source 1" style="zoom:75%;" />

* **2002-2006**: Use ultimate Loan Application Register (LAR) data which is available at [National Archives NextGen Catalog](https://catalog.archives.gov/id/2580741)

<img src="data%20source%202.png" alt="data source 2" style="zoom:75%;" />

