# README - Survey of Income

## I. Pipeline

* **Input**:
    * `output/`: the compressed `.zip` files downloaded from IRS. The python program unzip these files automatically
* **Processing files**:
    * Step 0: manually fix some data issues in the `.zip` files (year 2007, 2008, 2009). Check [README-extra.md](README-extra.md) for details
    * Step 1: `main.py` + `option.json`: unzip, process, and align across years for 2003-2012 data
    * Step 2: `main2.do`: process 2013-2019 data; append the cleaned year files as Stata file
* **Output**: 
    * `soi.dta`
    
* **Variables**
    * `soi.dta`:
        * `fips`: County 5-digit FIPS
        * `year`
        * `fips_state`: State 2-digit FIPS
        * `fips_county`: County 3-digit FIPS
        * `soi_agi`: Adjusted gross income in thousand-dollars
        * `soi_sws`: Salaries and wages in AGI in thousand-dollars
        * `soi_div`: Ordinary dividends before tax in thousand-dollars
        * `soi_int`: Taxable interests in thousand-dollars

## II. Data download

* Data source: [SOI Tax Stats - County data | Internal Revenue Service (irs.gov)](https://www.irs.gov/statistics/soi-tax-stats-county-data)

<img src="data%20source.png" alt="data source" style="zoom:75%;" />

## III. Data processing tricks

* `main.py`
    * The SOI data is in `.xls` format before 2011. Since 2012, it is in `.csv` files.
    * The naming rule of 2003-2009 and 2010-2012 are different. The two time periods are processed separately
    * The column information is saved in the `option.json` which handles all detailed and complex data harmonization

<img src="data%20source%202.png" alt="data source 2" style="zoom:75%;" />

## IV. Directory tree

```cmd
D:.
│   main.py
│   main2.do
│   option.json
│   README.md
│   soi.dta
│
├───original
│       2003countyincome.zip
│       2004countyincome.zip
│       2005countyincome.zip
│       2006countyincome.zip
│       2007countyincome - fixed.zip
│       2007countyincome.zip
│       2008countyincome - fixed.zip
│       2008countyincome.zip
│       2009countyincome - fixed.zip
│       2009countyincome.zip
│       2010countydata.zip
│       2011countydata.zip
│       2012countydata.zip
│       2013countydata.zip
│       2014countydata.zip
│       2015countydata.zip
│       2016countydata.zip
│       2017countydata.zip
│       2018countydata.zip
│       2019countydata.zip
│       New Internet Shortcut.url
│       README.md
│
├───output
│       13incyall.xls
│       14incyall.xls
│       15incyall.xls
│       16incyall.xls
│       17incyall.xlsx
│       18incyall.xlsx
│       19incyall.xlsx
│       soi0312.csv
│       soi1319.xlsx
│
└───src
    │   util.py
    │   __init__.py
```
