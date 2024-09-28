# README - Personal Consumption Expenditure (PCE)

## I. Pipeline

* **Input**:
    * `SAEXP2__ALL_AREAS_1997_2019.csv`
* **Processing files**:
    * `make.do`
* **Output**: 
    * `pce.dta`
    
* **Variables**
    * `pce.dta`:
        * `year`
        * `fips_state`: State 2-digit FIPS
        * `pce`
        * `pce_dura`: PCE of durable goods
        * `pce_nond`: PCE of non-durable goods
        * `pce_serv`: PCE of service

## II. Data download

* Data source: [apps.bea.gov/histdatacore/Regional_Accounts_new.html](https://apps.bea.gov/histdatacore/Regional_Accounts_new.html)

<img src="data%20source.png" alt="data source" style="zoom:75%;" />

## III. Data processing tricks

None

## IV. Directory tree

```cmd
D:.
│   make.do
│   pce.dta
│   README.md
│
└───original
        SAEXP2__ALL_AREAS_1997_2019.csv
```
