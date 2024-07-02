# README - NAICS

## I. Pipeline

* **Input**: [North American Industry Classification System (NAICS) U.S. Census Bureau](https://www.census.gov/naics/?48967)
    * `naics_2_6_02.txt`: 2002 version NAICS code file
    * `naics07.xls`: 2007 version
    * `2-digit_2012_Codes.xls`: 2012 version
    * `2-6 digit_2-17_Codes.xlsx`: 2017 version
    * `2-6 digit_2022_Codes.xlsx`: 2022 version
    * `2002_to_2007_NAICS.xls`: Concordance file, 2002-2007
    * `2007_to_2012_NAICS.xls`
    * `2012_to_2017_NAICS.xlsx`
    * `2017_to_2022_NAICS.xlsx`
* **Processing files**:
    * `make.py`
* **Output**: 
    * `naics_4digit_07key.csv`: time aligned NAICS code, merging all versions
    * `naics02_4digit.csv`: aligned code, 2002 version only
    * `naics07_4digit.csv`
    * `naics12_4digit.csv`
    * `naics17_4digit.csv`
    * `naics22_4digit.csv`
* **Variables**
    * `naics`: 4-digit NAICS code
    * `sector`: tradable, non-tradable, construction, or other
    * `naics07`: This industry’s 2007 version NAICS code
    * `ind07`: Industry name in 2007 version NAICS
    * `naics02`
    * `ind02`
    * `naics12`
    * `ind12`
    * `naics17`
    * `ind17`
    * `naics22`
    * `ind22`

## II. Data download

<img src="./data%20source.jpg" alt="data source" style="zoom:50%;" />

* Go to the NAICS on the Census Bureau website
* Download `2-6 digit yyyy Code File` as excel files (since 2007) or txt files (2002)
* We only clean 4-digit codes
* The cleaned NAICS code data works together with CBP data. For years between two versions of NAICS code, apply the earlier version. For example, year 02,03,...,06 apply to 2002 NAICS code.
* All the other year's 4-digit industries are absorbed to 2007 industries according to [Concordances files](https://www.census.gov/naics/?68967). A summary table is listed as follows:

| code_1997 | code_2002 | code_2012 | code_2017 | code_2022 | absorbed_by_2007 |
| --------- | --------- | --------- | --------- | --------- | ---------------- |
|           | 5161      |           |           | 5161      | 5191             |
|           | 5173      |           | 5173      |           | 5179             |
|           | 5175      |           |           |           | 5171             |
|           | 5181      |           |           |           | 5179             |
|           |           | 7225      | 7225      | 7225      | 7221             |
|           |           |           | 4522      |           | 4521             |
|           |           |           | 4523      |           | 4521             |
|           |           |           |           | 4491      | 4421             |
|           |           |           |           | 4492      | 4431             |
|           |           |           |           | 4551      | 4521             |
|           |           |           |           | 4552      | 4521             |
|           |           |           |           | 4561      | 4461             |
|           |           |           |           | 4571      | 4471             |
|           |           |           |           | 4572      | 4543             |
|           |           |           |           | 4581      | 4481             |
|           |           |           |           | 4582      | 4482             |
|           |           |           |           | 4583      | 4483             |
|           |           |           |           | 4591      | 4511             |
|           |           |           |           | 4592      | 4512             |
|           |           |           |           | 4593      | 4531             |
|           |           |           |           | 4594      | 4532             |
|           |           |           |           | 4595      | 4533             |
|           |           |           |           | 4599      | 4539             |
|           |           |           |           | 5131      | 5111             |
|           |           |           |           | 5132      | 5112             |
|           |           |           |           | 5162      | 5151             |
|           |           |           |           | 5178      | 5179             |
|           |           |           |           | 5192      | 5191             |
| 2331      |           |           |           |           | 2372             |

## III. Data processing tricks

- The code absorbing is hard coded in `make.py`.
- The 2007 code is used as the primary key of merging tables.

## IV. Directory tree

Here is our directory tree for reference:

```cmd
D:.
│   make.py
│   naics02_4digit.csv
│   naics07_4digit.csv
│   naics12_4digit.csv
│   naics17_4digit.csv
│   naics22_4digit.csv
│   naics_4digit_07key.csv
│   README.md
│
└───original
    │   concordance.xlsx
    │
    ├───2002
    │       naics_2_6_02.txt
    │
    ├───2007
    │       naics07.xls
    │
    ├───2012
    │       2-digit_2012_Codes.xls
    │
    ├───2017
    │       2-6 digit_2017_Codes.xlsx
    │
    ├───2022
    │       2-6 digit_2022_Codes.xlsx
    │
    └───concordance
            2002_to_2007_NAICS.xls
            2007_to_2012_NAICS.xls
            2012_to_2017_NAICS.xlsx
            2017_to_2022_NAICS.xlsx
```

