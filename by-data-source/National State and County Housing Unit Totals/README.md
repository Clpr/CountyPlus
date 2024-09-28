# README - National State and County Housing Unit Totals

## I. Pipeline

* **Input**:
    * `hu-est00int-tot.csv`: 2000-2010
    * `HU-EST2020_ALL.csv`: 2010-2020
* **Processing files**:
    * `make.do`
* **Output**: 
    * `thu.dta`
    
* **Variables**
    * `thu.dta`:
        * `fips`: County 5-digit FIPS
        * `year`
        * `cb_huest`: Total housing units estimates

## II. Data download

* Data source: https://www.census.gov/data/datasets/time-series/demo/popest/2010s-total-housing-units.html
    * Go to FTP2 site to download original files
    * 2010-2019: `https://www2.census.gov/programs-surveys/popest/datasets/2010-2020/housing/HU-EST2020_ALL.csv`
    * 2000-2010: `https://www2.census.gov/programs-surveys/popest/datasets/2000-2010/intercensal/housing/hu-est00int-tot.csv`

> Notes: The directory hierarchy of the above paths are the folder hierarchy on the FTP2 site as well.

<img src="data%20source%201.png" alt="data source 1" style="zoom:75%;" />

<img src="data%20source%202.png" alt="data source 2" style="zoom:75%;" />




## III. Data processing tricks

None

## IV. Directory tree

```cmd
D:.
│   make.do
│   README.md
│   thu.dta
│
└───original
        hu-est00int-tot.csv
        HU-EST2020_ALL.csv
```
