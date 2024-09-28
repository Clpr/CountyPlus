# README - Home Mortgage Disclosure Act (HMDA)

This is a the Stage 2 of processing HMDA data.

## I. Pipeline

* **Input**:
    * `original/rawYYYY.dta` where `YYYY` is the year
* **Processing files**:
    * `make.do`
* **Output**: 
    * `hmda.dta`

* **Variables**
    * `hmda.dta`
        * `fips`: County 5-digit FIPS code
        * `year`
        * `fips_state`
        * `fips_county`
        * `hmda_totnum_complete`: Total completed transactions
        * `hmda_totnum_approval`: Total approved transactions
        * `hmda_totnum_denial`: Total denial transactions
        * `hmda_totnum_sex_male`: Total male applicants
        * `hmda_totnum_sex_female`: Total female applicants
        * `hmda_totnum_race_white`: Total white applicants
        * `hmda_totnum_race_black`: Total black applicants
        * `hmda_totnum_race_asian`: Total Asian applicants
        * `hmda_totnum_denial_collateral`: Total denial due to lack of collateral
        * `hmda_totnum_denial_d2incratio`: Total denial due to debt-income ratio
        * `hmda_totnum_denial_credithist`: Total denial due to credit history
        * `hmda_totnum_denial_insuffcash`: Total denial due to insufficient cash
        * `hmda_ratespread_pct_mean`: Mortgage spread in percentage points - Mean
        * `hmda_ratespread_pct_count`: Mortgage spread in percentage points- Count of data points
        * `hmda_ratespread_pct_median`: Mortgage spread in percentage points- Median
        * `hmda_ratespread_pct_var`: Mortgage spread in percentage points - Variance

## II. Data download

Use the exported `rawYYYY.dta` files from Stage 1.

## III. Data processing tricks

None.

## IV. Directory tree

Here is a snapshot of my directory tree:

```cmd
D:.
│   hmda.dta
│   make.do
│   README.md
│
└───original
        raw2003.dta
        raw2004.dta
        raw2005.dta
        raw2006.dta
        raw2007.dta
        raw2008.dta
        raw2009.dta
        raw2010.dta
        raw2011.dta
        raw2012.dta
        raw2013.dta
        raw2014.dta
        raw2015.dta
        raw2016.dta
        raw2017.dta
        raw2018.dta
        raw2019.dta
```

