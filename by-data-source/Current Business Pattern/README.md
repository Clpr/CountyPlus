# README - County Business Pattern (CBP)

## I. Pipeline

* **Input**:
    * CPI by-year txt-format data files
    * Mian & Sufi (2014) industry classification (cleaned and saved in `../Mian Sufi 2014 Tradability/ms14sector.csv`)
* **Processing files**:
    * `make.do`: main cleaning
    * `fwcp.py`: construct FWCP (fraction of nominal wage cut prevented) friction indicator, the measure of downward nominal wage rigidity (DNWR)
* **Output**: 
    * CBP salary and employment data
        * `output/2003-2019.csv`: aggregate table, part of the CountyPlus dataset
        * `output/hhiyyyy.csv`: by-year (`yyyy`) Herfindahl index data, used to construct `2003-2019.csv`
        * `output/big_yyyy.csv`: by-year (`yyyy`) dis-aggregate tables, used to construct  FWCP variables
    
    * `output/fwcp04-19.csv`: constructed FWCP friction indicator, part of the CountyPlus dataset
    
* **Variables**
    * `output/2003-2019.csv`
        * `fips`: County FIPS code
        * `emp_tra`: Tradable employment, using Mian & Sufi (2013) NAICS classifications
        * `emp_non`: Non-tradable employment
        * `emp_con`: Construction sector employment
        * `emp_oth`: Other sector employment
        * `ap_tra`: Annual payroll of tradable sector
        * `ap_non`
        * `ap_con`
        * `ap_oth`
        * `herfindahl`: County employment-weighted average Herfindahl index, measuring the industry diversity of a county 
        * `est_tra`: Number of establishment, tradable
        * `est_non`
        * `est_con`
        * `est_oth`
        * `year`
    * `output/fwcp04-19.csv`
        * `year`
        * `fips`
        * `fwcp`: Fraction of nominal wage cut prevented, the measure of downward nominal wage rigidity (DNWR); using the methodology in Holden and Wulfsberg (2009)
        * `p`: fraction of observed nominal wage cut
        * `ptilde`: fraction of notional nominal wage cut

## II. Data download

<img src="./data%20source.jpg" alt="data source" style="zoom:50%;" />

* Data source: [CBP Datasets (census.gov)](https://www.census.gov/programs-surveys/cbp/data/datasets.html)
    * The downloaded data are saved as `txt` files. **They are very large (about 2.75 GB)**. Prepare enough disk space.
    * If you do not save these data files as shown in my directory tree below, then do remember to modify the python scripts.
* Run: `make.py`
    * Output: `output/2003-2019.csv`. It includes:
        * Employment by sector based on Mian & Sufi (2014) classification
        * County employment-weighted average Herfindahl index
        * Number of establishments
        * Annual payroll
    * Output: `output/big_yyyy.csv`. `yyyy=2002,...,2019`. They include:
        * 4-digit industry level data. Used to construct the measure of DNWR
    * Output: `output/hhiyyyy.csv`. They include:
        * HHI for each 4-digit industry in each year
* Run: `fwcp.py`
    * Source: the `output/big_yyyy.csv` files created by `make.py`
    * Output: `output/fwcp04-19.csv` for fraction of wage cuts prevented (FWCP) in each year, the measure of DNWR
* Special technical notes:
    * Since 2017, a cell (county-industry pair) is only published if it contains three or more establishments. In all other cases, the cell is not included in the release (i.e., it is dropped from publication). This change significantly reduces the number of available counties. For simplicity, we use MA(3) to do projections
    * The constructed FWCP measure is missing for year 2003 by construction

## III. Data processing tricks

* `make.py`
    * I use `datatables` for performance on large data files. Check its [Home — datatable documentation](https://datatable.readthedocs.io/en/latest/) if you are not familiar with it
    * NAICS code needs alignment across different years/versions. This is processed by `ms14chks` as a dictionary. Check the `by-data-source/Mian Sufi 2014 Tradability/` of this GitHub project for more explanation about how we did the code alignment.
    * The variable naming in the 2015 CBP data `txt` files is all capital letters, while they are all lower cases in the other years.
    * The Herfindahl index is computed at 4-digit NAICS industry level to be consistent with Mian & Sufi (2014)
    * This script takes time to run. It is not optimized for performance.
* `fwcp.py`
    * Check Holden and Wulfsberg (2009) or our paper (Ding & Zhao, 2024) for the mathematics and algorithm explanation.

## IV. Directory tree

Here is a snapshot of my directory tree:

```cmd
D:.
│   fwcp.py
│   make.py
│   README.md
│
├───original
│   ├───2002
│   │       Cbp02co.txt
│   │       county_layout.txt
│   │
│   ├───2003
│   │       cbp03co.txt
│   │       county_layout.txt
│   │
│   ├───2004
│   │       cbp04co.txt
│   │       county_layout.txt
│   │
│   ├───2005
│   │       cbp05co.txt
│   │       County Record Layout.txt
│   │
│   ├───2006
│   │       cbp06co.txt
│   │       County Record Layout.txt
│   │
│   ├───2007
│   │       Cbp07co.txt
│   │       county_layout.txt
│   │
│   ├───2008
│   │       Cbp08co.txt
│   │       county_layout.txt
│   │
│   ├───2009
│   │       cbp09co.txt
│   │       county_layout.txt
│   │
│   ├───2010
│   │       cbp10co.txt
│   │       county_layout.txt
│   │
│   ├───2011
│   │       cbp11co.txt
│   │       county_layout.txt
│   │
│   ├───2012
│   │       cbp12co.txt
│   │       county_layout.txt
│   │
│   ├───2013
│   │       cbp13co.txt
│   │       county_layout.txt
│   │       georef12.txt
│   │
│   ├───2014
│   │       cbp14co.txt
│   │
│   ├───2015
│   │       cbp15co.txt
│   │       county_layout_2015.txt
│   │
│   ├───2016
│   │       cbp16co.txt
│   │
│   ├───2017
│   │       cbp17co.txt
│   │
│   ├───2018
│   │       cbp18co.txt
│   │
│   └───2019
│           cbp19co.txt
│
└───output
        2003-2019.csv
        big_2003.csv
        big_2004.csv
        big_2005.csv
        big_2006.csv
        big_2007.csv
        big_2008.csv
        big_2009.csv
        big_2010.csv
        big_2011.csv
        big_2012.csv
        big_2013.csv
        big_2014.csv
        big_2015.csv
        big_2016.csv
        big_2017.csv
        big_2018.csv
        big_2019.csv
        fwcp04-19.csv
        hhi2003.csv
        hhi2004.csv
        hhi2005.csv
        hhi2006.csv
        hhi2007.csv
        hhi2008.csv
        hhi2009.csv
        hhi2010.csv
        hhi2011.csv
        hhi2012.csv
        hhi2013.csv
        hhi2014.csv
        hhi2015.csv
        hhi2016.csv
        hhi2017.csv
        hhi2018.csv
        hhi2019.csv
```

## Reference

- Holden, S. and Wulfsberg, F. (2009). How strong is the macroeconomic case for downward real wage rigidity? *Journal of monetary Economics*, 56(4):605–615.
- Mian, A., Rao, K., and Sufi, A. (2013). Household balance sheets, consumption, and the economic slump. *The Quarterly Journal of Economics*, 128(4):1687–1726.
- Mian, A. and Sufi, A. (2014). What explains the 2007–2009 drop in employment? *Econometrica*, 82(6):2197–2223.
- Ding. C. and Zhao, T. (2024). Nonlinear Heterogeneous Impact of Net Worth Shocks. *Working paper*.