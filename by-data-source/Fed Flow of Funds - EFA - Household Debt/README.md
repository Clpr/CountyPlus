# README - Enhanced Financial Accounts of Flow of Funds

## I. Pipeline

* **Input**: [The Fed - Household Debt Overview (federalreserve.gov)](https://www.federalreserve.gov/releases/z1/dataviz/household_debt/)

<img src="README.assets/data%20source.png" alt="data source" style="zoom:75%;" />

The *Enhanced Financial Accounts* has dis-aggregate data of households at: state, county and MSA levels.

- Step1: Download CSV of *Explore Map by Counties*. The data start from 1999
- Step2: Unzip the download file and get `household-debt-by-county.csv` as input
- Step3: Run `make.do`

* **Processing files**:
    * `make.do`
* **Output**: 
    * `d2y.dta`
* **Variables**
    * `ffof_efa_d2ylb`: Debt-income ratio, lower bound
    * `ffof_efa_d2yub` : Debt-income ratio, upper bound
    * `ffof_efa_d2y`: Debt-income ratio


## III. Data processing notes

- The original data is quarterly. We use annual average.
- The original data are intervals of debt-income ratios. We use the middle value of the intervals as our debt-income ratio

## IV. Directory tree

Here is our directory tree for reference:

```cmd
D:.
│   d2y.dta
│   make.do
│   README.md
│
└───original
        household-debt-by-county.csv
```

