# README - Small Area Income and Poverty Estimates (SAIPE)

## I. Pipeline

* **Input**:
    * `input`
* **Processing files**:
    * ==Data are pre-cleaned in the downloaded excel files due to the naming inconsistency across years. Please contact me if you want exact the modified excel files==
        * For each Excel file, we selected & renamed variables in a new work sheet `cleaned`. Check following sections for the variable renaming rules
    * `make.do`
* **Output**: 
    * `saipe.dta`
    
* **Variables**
    * `saipe.dta`:
        * `fips`: County 5-digit FIPS
        * `year`
        * `fips_state`: State 2-digit FIPS
        * `fips_county`: County 3-digit FIPS
        * `poverty_popu`: Poverty population
        * `poverty_pct`: Poverty rate in percentage points
        * `mid_finc`: Median family income in dollar

## II. Data download

* Data source: [Small Area Income and Poverty Estimates (SAIPE) Program (census.gov)](https://www.census.gov/programs-surveys/saipe.html)
    * Download year by year


<img src="data%20source.png" alt="data source" style="zoom:75%;" />



## III. Data processing tricks

Using 2012 as an example:

| Name in original downloaded file | Renamed as     |
| -------------------------------- | -------------- |
| State FIPS Code                  | `fips_state`   |
| County FIPS Code                 | `fips_county`  |
| Poverty Estimate, All Ages       | `poverty_popu` |
| Poverty Percent, All Ages        | `poverty_pct`  |
| Median Household Income          | `mid_finc`     |

> Tips: 1. Interval estimates are available in the SAIPE; 2. Yong-age ($<18$ years old) poverty data are available in the SAIPE.

## IV. Directory tree

```cmd
D:.
│   make.do
│   README.md
│   saipe.dta
│
└───original
        est2003all.xls
        est2004all.xls
        est2005all.xls
        est2006all.xls
        est2007all.xls
        est2008all.xls
        est2009all.xls
        est2010all.xls
        est2011all.xls
        est2012all.xls
        est2013all.xls
        est2014all.xls
        est2015all.xls
        est2016all.xls
        est2017all.xls
        est2018all.xls
        est2019all.xls
```
