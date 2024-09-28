# README - Data name

## I. Pipeline

* **Input**:
    * `input`
* **Processing files**:
    * `make.do`
* **Output**: 
    * `oputput.dta`
    
* **Variables**
    * `output.dta`:
        * `fips`: County 5-digit FIPS
        * `year`
        * `fips_state`: State 2-digit FIPS
        * `fips_county`: County 3-digit FIPS

## II. Data download

* Data source: [CBP Datasets (census.gov)](https://www.census.gov/programs-surveys/cbp/data/datasets.html)

## III. Data processing tricks

* `make.py`
    * I use `datatables` for performance on large data files etc.

## IV. Directory tree

```cmd
D:.
│   fwcp.py
│   make.py
│   README.md
│
├───original
│   │       Cbp02co.txt
│   │       county_layout.txt
```
