# README - Vintage Population Estimates for Demographics

## I. Pipeline

* **Input**:
    * `input`
* **Processing files**:
    * Step 1: `download_data.ipynb`: automatically download state files of 2003-2010
    * Step 2: `process.do`
* **Output**: 
    * `rawYYYY.dta`: intermediate files where `YYYY` is year
    * `vpe.dta`: the final output
    
* **Variables**
    * `output.dta`:
        * `fips`: County 5-digit FIPS
        * `year`
        * `fips_state`: State 2-digit FIPS
        * `fips_county`: County 3-digit FIPS
        * `vpe_totpopu`: Total population
        * `vpe_totpopu_male`: Population of male
        * `vpe_totpopu_female`: Population of female
        * `vpe_totpopu_white`: Population of white
        * `vpe_totpopu_black`: Population of black
        * `vpe_avgage`: Population of average age
        * `vpe_totpopu_work`: Population of working age (15-70)

## II. Data download

* Data source: [Index of /programs-surveys/popest/datasets (census.gov)](https://www2.census.gov/programs-surveys/popest/datasets/)
    * e.g. Open the link, go to subdirectories e.g. `~/2010-2011/counties/asrh/` to get county-level data by age, sex and race
* For data of year before 2010, each state has its own file.


## III. Data processing tricks

* `make.py`
    * I use `datatables` for performance on large data files etc.

## IV. Directory tree

```cmd
D:.
│   download_data.ipynb
│   preprocess.ipynb
│   process.do
│   README.md
│
├───2000-2003
│       cc-est2003-alldata-01.csv
│       cc-est2003-alldata-02.csv
│       cc-est2003-alldata-04.csv
│       cc-est2003-alldata-05.csv
│       cc-est2003-alldata-06.csv
│       cc-est2003-alldata-08.csv
│       cc-est2003-alldata-09.csv
│       cc-est2003-alldata-10.csv
│       cc-est2003-alldata-11.csv
│       cc-est2003-alldata-12.csv
│       cc-est2003-alldata-13.csv
│       cc-est2003-alldata-15.csv
│       cc-est2003-alldata-16.csv
│       cc-est2003-alldata-17.csv
│       cc-est2003-alldata-18.csv
│       cc-est2003-alldata-19.csv
│       cc-est2003-alldata-20.csv
│       cc-est2003-alldata-21.csv
│       cc-est2003-alldata-22.csv
│       cc-est2003-alldata-23.csv
│       cc-est2003-alldata-24.csv
│       cc-est2003-alldata-25.csv
│       cc-est2003-alldata-26.csv
│       cc-est2003-alldata-27.csv
│       cc-est2003-alldata-28.csv
│       cc-est2003-alldata-29.csv
│       cc-est2003-alldata-30.csv
│       cc-est2003-alldata-31.csv
│       cc-est2003-alldata-32.csv
│       cc-est2003-alldata-33.csv
│       cc-est2003-alldata-34.csv
│       cc-est2003-alldata-35.csv
│       cc-est2003-alldata-36.csv
│       cc-est2003-alldata-37.csv
│       cc-est2003-alldata-38.csv
│       cc-est2003-alldata-39.csv
│       cc-est2003-alldata-40.csv
│       cc-est2003-alldata-41.csv
│       cc-est2003-alldata-42.csv
│       cc-est2003-alldata-44.csv
│       cc-est2003-alldata-45.csv
│       cc-est2003-alldata-46.csv
│       cc-est2003-alldata-47.csv
│       cc-est2003-alldata-48.csv
│       cc-est2003-alldata-49.csv
│       cc-est2003-alldata-50.csv
│       cc-est2003-alldata-51.csv
│       cc-est2003-alldata-53.csv
│       cc-est2003-alldata-54.csv
│       cc-est2003-alldata-55.csv
│       cc-est2003-alldata-56.csv
│       co-est00int-sexracehisp.pdf
│       raw2003.dta
│
├───2000-2004
│       cc_est2004_alldata_01.csv
│       cc_est2004_alldata_02.csv
│       cc_est2004_alldata_04.csv
│       cc_est2004_alldata_05.csv
│       cc_est2004_alldata_06.csv
│       cc_est2004_alldata_08.csv
│       cc_est2004_alldata_09.csv
│       cc_est2004_alldata_10.csv
│       cc_est2004_alldata_11.csv
│       cc_est2004_alldata_12.csv
│       cc_est2004_alldata_13.csv
│       cc_est2004_alldata_15.csv
│       cc_est2004_alldata_16.csv
│       cc_est2004_alldata_17.csv
│       cc_est2004_alldata_18.csv
│       cc_est2004_alldata_19.csv
│       cc_est2004_alldata_20.csv
│       cc_est2004_alldata_21.csv
│       cc_est2004_alldata_22.csv
│       cc_est2004_alldata_23.csv
│       cc_est2004_alldata_24.csv
│       cc_est2004_alldata_25.csv
│       cc_est2004_alldata_26.csv
│       cc_est2004_alldata_27.csv
│       cc_est2004_alldata_28.csv
│       cc_est2004_alldata_29.csv
│       cc_est2004_alldata_30.csv
│       cc_est2004_alldata_31.csv
│       cc_est2004_alldata_32.csv
│       cc_est2004_alldata_33.csv
│       cc_est2004_alldata_34.csv
│       cc_est2004_alldata_35.csv
│       cc_est2004_alldata_36.csv
│       cc_est2004_alldata_37.csv
│       cc_est2004_alldata_38.csv
│       cc_est2004_alldata_39.csv
│       cc_est2004_alldata_40.csv
│       cc_est2004_alldata_41.csv
│       cc_est2004_alldata_42.csv
│       cc_est2004_alldata_44.csv
│       cc_est2004_alldata_45.csv
│       cc_est2004_alldata_46.csv
│       cc_est2004_alldata_47.csv
│       cc_est2004_alldata_48.csv
│       cc_est2004_alldata_49.csv
│       cc_est2004_alldata_50.csv
│       cc_est2004_alldata_51.csv
│       cc_est2004_alldata_53.csv
│       cc_est2004_alldata_54.csv
│       cc_est2004_alldata_55.csv
│       cc_est2004_alldata_56.csv
│       raw2004.dta
│
├───2000-2005
│       cc-est2005-alldata-01.csv
│       cc-est2005-alldata-02.csv
│       cc-est2005-alldata-04.csv
│       cc-est2005-alldata-05.csv
│       cc-est2005-alldata-06.csv
│       cc-est2005-alldata-08.csv
│       cc-est2005-alldata-09.csv
│       cc-est2005-alldata-10.csv
│       cc-est2005-alldata-11.csv
│       cc-est2005-alldata-12.csv
│       cc-est2005-alldata-13.csv
│       cc-est2005-alldata-15.csv
│       cc-est2005-alldata-16.csv
│       cc-est2005-alldata-17.csv
│       cc-est2005-alldata-18.csv
│       cc-est2005-alldata-19.csv
│       cc-est2005-alldata-20.csv
│       cc-est2005-alldata-21.csv
│       cc-est2005-alldata-22.csv
│       cc-est2005-alldata-23.csv
│       cc-est2005-alldata-24.csv
│       cc-est2005-alldata-25.csv
│       cc-est2005-alldata-26.csv
│       cc-est2005-alldata-27.csv
│       cc-est2005-alldata-28.csv
│       cc-est2005-alldata-29.csv
│       cc-est2005-alldata-30.csv
│       cc-est2005-alldata-31.csv
│       cc-est2005-alldata-32.csv
│       cc-est2005-alldata-33.csv
│       cc-est2005-alldata-34.csv
│       cc-est2005-alldata-35.csv
│       cc-est2005-alldata-36.csv
│       cc-est2005-alldata-37.csv
│       cc-est2005-alldata-38.csv
│       cc-est2005-alldata-39.csv
│       cc-est2005-alldata-40.csv
│       cc-est2005-alldata-41.csv
│       cc-est2005-alldata-42.csv
│       cc-est2005-alldata-44.csv
│       cc-est2005-alldata-45.csv
│       cc-est2005-alldata-46.csv
│       cc-est2005-alldata-47.csv
│       cc-est2005-alldata-48.csv
│       cc-est2005-alldata-49.csv
│       cc-est2005-alldata-50.csv
│       cc-est2005-alldata-51.csv
│       cc-est2005-alldata-53.csv
│       cc-est2005-alldata-54.csv
│       cc-est2005-alldata-55.csv
│       cc-est2005-alldata-56.csv
│       raw2005.dta
│
├───2000-2006
│       cc-est2006-alldata-01.csv
│       cc-est2006-alldata-02.csv
│       cc-est2006-alldata-04.csv
│       cc-est2006-alldata-05.csv
│       cc-est2006-alldata-06.csv
│       cc-est2006-alldata-08.csv
│       cc-est2006-alldata-09.csv
│       cc-est2006-alldata-10.csv
│       cc-est2006-alldata-11.csv
│       cc-est2006-alldata-12.csv
│       cc-est2006-alldata-13.csv
│       cc-est2006-alldata-15.csv
│       cc-est2006-alldata-16.csv
│       cc-est2006-alldata-17.csv
│       cc-est2006-alldata-18.csv
│       cc-est2006-alldata-19.csv
│       cc-est2006-alldata-20.csv
│       cc-est2006-alldata-21.csv
│       cc-est2006-alldata-22.csv
│       cc-est2006-alldata-23.csv
│       cc-est2006-alldata-24.csv
│       cc-est2006-alldata-25.csv
│       cc-est2006-alldata-26.csv
│       cc-est2006-alldata-27.csv
│       cc-est2006-alldata-28.csv
│       cc-est2006-alldata-29.csv
│       cc-est2006-alldata-30.csv
│       cc-est2006-alldata-31.csv
│       cc-est2006-alldata-32.csv
│       cc-est2006-alldata-33.csv
│       cc-est2006-alldata-34.csv
│       cc-est2006-alldata-35.csv
│       cc-est2006-alldata-36.csv
│       cc-est2006-alldata-37.csv
│       cc-est2006-alldata-38.csv
│       cc-est2006-alldata-39.csv
│       cc-est2006-alldata-40.csv
│       cc-est2006-alldata-41.csv
│       cc-est2006-alldata-42.csv
│       cc-est2006-alldata-44.csv
│       cc-est2006-alldata-45.csv
│       cc-est2006-alldata-46.csv
│       cc-est2006-alldata-47.csv
│       cc-est2006-alldata-48.csv
│       cc-est2006-alldata-49.csv
│       cc-est2006-alldata-50.csv
│       cc-est2006-alldata-51.csv
│       cc-est2006-alldata-53.csv
│       cc-est2006-alldata-54.csv
│       cc-est2006-alldata-55.csv
│       cc-est2006-alldata-56.csv
│       raw2006.dta
│
├───2000-2007
│       cc-est2007-alldata-01.csv
│       cc-est2007-alldata-02.csv
│       cc-est2007-alldata-04.csv
│       cc-est2007-alldata-05.csv
│       cc-est2007-alldata-06.csv
│       cc-est2007-alldata-08.csv
│       cc-est2007-alldata-09.csv
│       cc-est2007-alldata-10.csv
│       cc-est2007-alldata-11.csv
│       cc-est2007-alldata-12.csv
│       cc-est2007-alldata-13.csv
│       cc-est2007-alldata-15.csv
│       cc-est2007-alldata-16.csv
│       cc-est2007-alldata-17.csv
│       cc-est2007-alldata-18.csv
│       cc-est2007-alldata-19.csv
│       cc-est2007-alldata-20.csv
│       cc-est2007-alldata-21.csv
│       cc-est2007-alldata-22.csv
│       cc-est2007-alldata-23.csv
│       cc-est2007-alldata-24.csv
│       cc-est2007-alldata-25.csv
│       cc-est2007-alldata-26.csv
│       cc-est2007-alldata-27.csv
│       cc-est2007-alldata-28.csv
│       cc-est2007-alldata-29.csv
│       cc-est2007-alldata-30.csv
│       cc-est2007-alldata-31.csv
│       cc-est2007-alldata-32.csv
│       cc-est2007-alldata-33.csv
│       cc-est2007-alldata-34.csv
│       cc-est2007-alldata-35.csv
│       cc-est2007-alldata-36.csv
│       cc-est2007-alldata-37.csv
│       cc-est2007-alldata-38.csv
│       cc-est2007-alldata-39.csv
│       cc-est2007-alldata-40.csv
│       cc-est2007-alldata-41.csv
│       cc-est2007-alldata-42.csv
│       cc-est2007-alldata-44.csv
│       cc-est2007-alldata-45.csv
│       cc-est2007-alldata-46.csv
│       cc-est2007-alldata-47.csv
│       cc-est2007-alldata-48.csv
│       cc-est2007-alldata-49.csv
│       cc-est2007-alldata-50.csv
│       cc-est2007-alldata-51.csv
│       cc-est2007-alldata-53.csv
│       cc-est2007-alldata-54.csv
│       cc-est2007-alldata-55.csv
│       cc-est2007-alldata-56.csv
│       raw2007.dta
│
├───2000-2008
│       cc-est2008-alldata-01.csv
│       cc-est2008-alldata-02.csv
│       cc-est2008-alldata-04.csv
│       cc-est2008-alldata-05.csv
│       cc-est2008-alldata-06.csv
│       cc-est2008-alldata-08.csv
│       cc-est2008-alldata-09.csv
│       cc-est2008-alldata-10.csv
│       cc-est2008-alldata-11.csv
│       cc-est2008-alldata-12.csv
│       cc-est2008-alldata-13.csv
│       cc-est2008-alldata-15.csv
│       cc-est2008-alldata-16.csv
│       cc-est2008-alldata-17.csv
│       cc-est2008-alldata-18.csv
│       cc-est2008-alldata-19.csv
│       cc-est2008-alldata-20.csv
│       cc-est2008-alldata-21.csv
│       cc-est2008-alldata-22.csv
│       cc-est2008-alldata-23.csv
│       cc-est2008-alldata-24.csv
│       cc-est2008-alldata-25.csv
│       cc-est2008-alldata-26.csv
│       cc-est2008-alldata-27.csv
│       cc-est2008-alldata-28.csv
│       cc-est2008-alldata-29.csv
│       cc-est2008-alldata-30.csv
│       cc-est2008-alldata-31.csv
│       cc-est2008-alldata-32.csv
│       cc-est2008-alldata-33.csv
│       cc-est2008-alldata-34.csv
│       cc-est2008-alldata-35.csv
│       cc-est2008-alldata-36.csv
│       cc-est2008-alldata-37.csv
│       cc-est2008-alldata-38.csv
│       cc-est2008-alldata-39.csv
│       cc-est2008-alldata-40.csv
│       cc-est2008-alldata-41.csv
│       cc-est2008-alldata-42.csv
│       cc-est2008-alldata-44.csv
│       cc-est2008-alldata-45.csv
│       cc-est2008-alldata-46.csv
│       cc-est2008-alldata-47.csv
│       cc-est2008-alldata-48.csv
│       cc-est2008-alldata-49.csv
│       cc-est2008-alldata-50.csv
│       cc-est2008-alldata-51.csv
│       cc-est2008-alldata-53.csv
│       cc-est2008-alldata-54.csv
│       cc-est2008-alldata-55.csv
│       cc-est2008-alldata-56.csv
│       raw2008.dta
│
├───2000-2009
│       cc-est2009-alldata-01.csv
│       cc-est2009-alldata-02.csv
│       cc-est2009-alldata-04.csv
│       cc-est2009-alldata-05.csv
│       cc-est2009-alldata-06.csv
│       cc-est2009-alldata-08.csv
│       cc-est2009-alldata-09.csv
│       cc-est2009-alldata-10.csv
│       cc-est2009-alldata-11.csv
│       cc-est2009-alldata-12.csv
│       cc-est2009-alldata-13.csv
│       cc-est2009-alldata-15.csv
│       cc-est2009-alldata-16.csv
│       cc-est2009-alldata-17.csv
│       cc-est2009-alldata-18.csv
│       cc-est2009-alldata-19.csv
│       cc-est2009-alldata-20.csv
│       cc-est2009-alldata-21.csv
│       cc-est2009-alldata-22.csv
│       cc-est2009-alldata-23.csv
│       cc-est2009-alldata-24.csv
│       cc-est2009-alldata-25.csv
│       cc-est2009-alldata-26.csv
│       cc-est2009-alldata-27.csv
│       cc-est2009-alldata-28.csv
│       cc-est2009-alldata-29.csv
│       cc-est2009-alldata-30.csv
│       cc-est2009-alldata-31.csv
│       cc-est2009-alldata-32.csv
│       cc-est2009-alldata-33.csv
│       cc-est2009-alldata-34.csv
│       cc-est2009-alldata-35.csv
│       cc-est2009-alldata-36.csv
│       cc-est2009-alldata-37.csv
│       cc-est2009-alldata-38.csv
│       cc-est2009-alldata-39.csv
│       cc-est2009-alldata-40.csv
│       cc-est2009-alldata-41.csv
│       cc-est2009-alldata-42.csv
│       cc-est2009-alldata-44.csv
│       cc-est2009-alldata-45.csv
│       cc-est2009-alldata-46.csv
│       cc-est2009-alldata-47.csv
│       cc-est2009-alldata-48.csv
│       cc-est2009-alldata-49.csv
│       cc-est2009-alldata-50.csv
│       cc-est2009-alldata-51.csv
│       cc-est2009-alldata-53.csv
│       cc-est2009-alldata-54.csv
│       cc-est2009-alldata-55.csv
│       cc-est2009-alldata-56.csv
│       raw2009.dta
│
├───2000-2010
│   │   co-est00int-alldata-01.csv
│   │   co-est00int-alldata-02.csv
│   │   co-est00int-alldata-04.csv
│   │   co-est00int-alldata-05.csv
│   │   co-est00int-alldata-06.csv
│   │   co-est00int-alldata-08.csv
│   │   co-est00int-alldata-09.csv
│   │   co-est00int-alldata-10.csv
│   │   co-est00int-alldata-11.csv
│   │   co-est00int-alldata-12.csv
│   │   co-est00int-alldata-13.csv
│   │   co-est00int-alldata-15.csv
│   │   co-est00int-alldata-16.csv
│   │   co-est00int-alldata-17.csv
│   │   co-est00int-alldata-18.csv
│   │   co-est00int-alldata-19.csv
│   │   co-est00int-alldata-20.csv
│   │   co-est00int-alldata-21.csv
│   │   co-est00int-alldata-22.csv
│   │   co-est00int-alldata-23.csv
│   │   co-est00int-alldata-24.csv
│   │   co-est00int-alldata-25.csv
│   │   co-est00int-alldata-26.csv
│   │   co-est00int-alldata-27.csv
│   │   co-est00int-alldata-28.csv
│   │   co-est00int-alldata-29.csv
│   │   co-est00int-alldata-30.csv
│   │   co-est00int-alldata-31.csv
│   │   co-est00int-alldata-32.csv
│   │   co-est00int-alldata-33.csv
│   │   co-est00int-alldata-34.csv
│   │   co-est00int-alldata-35.csv
│   │   co-est00int-alldata-36.csv
│   │   co-est00int-alldata-37.csv
│   │   co-est00int-alldata-38.csv
│   │   co-est00int-alldata-39.csv
│   │   co-est00int-alldata-4-25-13.pdf
│   │   co-est00int-alldata-40.csv
│   │   co-est00int-alldata-41.csv
│   │   co-est00int-alldata-42.csv
│   │   co-est00int-alldata-44.csv
│   │   co-est00int-alldata-45.csv
│   │   co-est00int-alldata-46.csv
│   │   co-est00int-alldata-47.csv
│   │   co-est00int-alldata-48.csv
│   │   co-est00int-alldata-49.csv
│   │   co-est00int-alldata-50.csv
│   │   co-est00int-alldata-51.csv
│   │   co-est00int-alldata-53.csv
│   │   co-est00int-alldata-54.csv
│   │   co-est00int-alldata-55.csv
│   │   co-est00int-alldata-56.csv
│   │   raw2010.dta
│   │
│   └───.ipynb_checkpoints
├───2010-2011
│       cc-est2011-alldata.csv
│       cc-est2011-alldata.pdf
│
├───2010-2012
│       cc-est2012-alldata.csv
│       cc-est2012-alldata.pdf
│
├───2010-2013
│       cc-est2013-alldata.csv
│       cc-est2013-alldata.pdf
│
├───2010-2014
│       cc-est2014-alldata.csv
│       cc-est2014-alldata.pdf
│
├───2010-2015
│       cc-est2015-alldata.csv
│       cc-est2015-alldata.pdf
│
├───2010-2016
│       cc-est2016-alldata.csv
│       cc-est2016-alldata.pdf
│
├───2010-2017
│       cc-est2017-alldata.csv
│       cc-est2017-alldata.pdf
│
├───2010-2018
│       cc-est2018-alldata.csv
│
├───2010-2019
│       cc-est2019-alldata.csv
│
├───2010-2020
│       CC-EST2020-ALLDATA6.csv
│
└───output
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
        vpe.dta
```
