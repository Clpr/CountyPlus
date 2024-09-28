# README - Local Area Unemployment Statistics (LAUS)

## I. Pipeline

* Data source: [LAUS Home : U.S. Bureau of Labor Statistics (bls.gov)](https://www.bls.gov/lau/tables.htm)
* **Input**:
    * `laucnty****.xlsx` where `***` is the 4-digit year (for years using 2-digit year, we convert it to 4-digit year)
* **Processing files**:
    * `make.do`
* **Output**: 
    * `laus.dta`
    
* **Variables**
    * `fips_state`
    * `fips_county`
    * `year`
    * `labor_force`: Labor force population
    * `emp_popu`: Employed population
    * `unemp_popu`: Unemployed population
    * `unemp_rate`: Unemployment rate in percentage points

## II. Data download

* First, go to BLS LAUS table page: https://www.bls.gov/lau/tables.htm
* Download county files and rename them if needed
* Run `main.do`

<img src="README.assets/data%20source%201.png" alt="data source 1" style="zoom:75%;" />

<img src="README.assets/data%20source%202.png" alt="data source 2" style="zoom:75%;" />

## IV. Directory tree

Here is a snapshot of my directory tree:

```cmd
D:.
│   laus.dta
│   make.do
│   README.md
│
└───original
        laucnty2003.xlsx
        laucnty2004.xlsx
        laucnty2005.xlsx
        laucnty2006.xlsx
        laucnty2007.xlsx
        laucnty2008.xlsx
        laucnty2009.xlsx
        laucnty2010.xlsx
        laucnty2011.xlsx
        laucnty2012.xlsx
        laucnty2013.xlsx
        laucnty2014.xlsx
        laucnty2015.xlsx
        laucnty2016.xlsx
        laucnty2017.xlsx
        laucnty2018.xlsx
        laucnty2019.xlsx
        laucnty2020.xlsx
```

