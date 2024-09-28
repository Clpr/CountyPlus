# README - USDA Educational Attainment for adults

## I. Pipeline

* **Input**:
    * `Education.xlsx`
* **Processing files**:
    * `main.do`
* **Output**: 
    * `usdaedu.dta`: This file is designed in “wide” format because education in a year usually serves as demographics
    
* **Variables**
    * `usdaedu.dta`:
        * `fips`: County 5-digit FIPS
        * `usda00_edupop_lesshigh`: 2000 Total population with degree: less than high school 
        * `usda00_edupop_highonly`: 2000 Total population with degree: High school
        * `usda00_edupop_assoonly`: 2000 Total population with degree: Associate degrees
        * `usda00_edupop_bachelor`: 2000 Total population with degree: Bachelor and higher
        * `usda00_edushr_lesshigh`: 2000 Share of population with degree: less than high school
        * `usda00_edushr_highonly`: 2000 Share of population with degree: High school
        * `usda00_edushr_assoonly`: 2000 Share of population with degree: Associate degrees
        * `usda00_edushr_bachelor`: 2000 Share of population with degree: Bachelor and higher
        * `usda08_edupop_lesshigh`: 2008 Total population with degree: less than high school 
        * `usda08_edupop_highonly`: 2008 Total population with degree: High school
        * `usda08_edupop_assoonly`: 2008 Total population with degree: Associate degrees
        * `usda08_edupop_bachelor`: 2008 Total population with degree: Bachelor and higher
        * `usda08_edushr_lesshigh`: 2008 Share of population with degree: less than high school
        * `usda08_edushr_highonly`: 2008 Share of population with degree: High school
        * `usda08_edushr_assoonly`: 2008 Share of population with degree: Associate degrees
        * `usda08_edushr_bachelor`: 2008 Share of population with degree: Bachelor and higher
        * `usda17_edupop_lesshigh`: 2017 Total population with degree: less than high school 
        * `usda17_edupop_highonly`: 2017 Total population with degree: High school
        * `usda17_edupop_assoonly`: 2017 Total population with degree: Associate degrees
        * `usda17_edupop_bachelor`: 2017 Total population with degree: Bachelor and higher
        * `usda17_edushr_lesshigh`: 2017 Share of population with degree: less than high school
        * `usda17_edushr_highonly`: 2017 Share of population with degree: High school
        * `usda17_edushr_assoonly`: 2017 Share of population with degree: Associate degrees
        * `usda17_edushr_bachelor`: 2017 Share of population with degree: Bachelor and higher

## II. Data download

* Data source: [USDA ERS - County-level Data Sets: Download Data](https://www.ers.usda.gov/data-products/county-level-data-sets/county-level-data-sets-download-data/)

<img src="data%20source.png" alt="data source" style="zoom:75%;" />

## III. Data processing tricks

None

## IV. Directory tree

```cmd
D:.
    data source.jpg
    Education.xlsx
    main.do
    usdaedu.dta
```
