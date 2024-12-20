# CountyPlus

## Release

The first release `v0.0.2` of _CountyPlus_ dataset is available now! You are welcome to download and explore the dataset.

## New in v0.0.2

- Add a separate file of constructed county-level net worth shocks since 2004
- Add spatial weighting matrices for spatial analysis
    - First-neighbor adjacency weight
    - Inverse distance weight (Haversine formula using latitude and longitude)

### Future plan

- Release `v0.0.3` (expected: Jan 2025):
    - Add variables of local government expenditure, esp. defense expenditure which is a widely used instrument
    - Larger coverage of consumption estimates, and distinguish between durable and non-durable goods consumption.

## About the dataset

*CountyPlus* dataset is an open-source county-level panel dataset for economic and social science research. It consists of 3000+ U.S. counties years from 2003 to 2019 while covering a broad collection of county-scope variables: 

- County geographic and demographic characteristics
- Household balance sheets e.g. holdings by asset type
- Household net worth shocks and a Bartik instrument
- Household income and consumption
- Local sales tax and taxable consumption
- Local labor market indicators such as wage and employment
- Local house market indicators such as house price and house ownership
- Local credit supply e.g. home mortgage loans
- Local industry size, payroll and industry diversity
- Indicators of local economic frictions
    - collateral constraint
    - Downward Nominal Wage Rigidity (DNWR)


The dataset uses all public available data sources for the best replicability. This GitHub repo provides detailed data documentation for *CountyPlus* dataset including:

- By data source cleaning instructions, institutional facts, explanation, and programming code
- Documentations and programs for merging to get the final dataset

One can replicate the whole dataset and every sub-project following the instruction and using program files. On the current stage, we are actively extending the dataset to cover more variables and time periods. If you have some questions, comments on this dataset, or would like to see some new variables related to your research, you are more than welcome to contact us. We very appreciate your valuable comments.

The rest of this README introduces how this repo is organized.

## Repo structure

This repo has two main folders:

- `src/`: this directory saves the Stata do-files that merge the outputs of the sub-projects, after-merge process, and export the final `CountyPlus.dta` dataset. One may use `main.do` to call the whole pipeline.
    - [x] `id.do`: Table: ID (primary key)
    - [x] `ap.do`: Table: Aggregate prices
    - [x] `bs.do`: Table: Household balance sheet
    - [x] `cp.do`: Table: Consumption
    - [x] `cs.do`: Table: Credit supply
    - [x] `dg.do`: Table: Demography
    - [x] `lg.do`: Table: Land and Geography
    - [x] `yl.do`: Table: Income, poverty, and labor market
    - [x] `postproc.do`: Post-merging processes
- `by-data-source/`: this directory saves the documentation by data source and corresponding program files. The output of these “sub-projects” are used in the data merging. The following is a list of all data sources (checked box: has uploaded to GitHub; unchecked box: still on the way)
    - [x] `American Community Survey/`: ACS data, to obtain estimate median housing value in 2019
    - [x] `County Land Areas/`: County area and latitude/longitude data
    - [x] `CPI All Urban Consumers/`: Inflation
    - [x] `Current Business Pattern/`: To construct county-industry level, and tradable/non-tradable sector level employment & employment. Also to construct DNWR measure (fraction of wage cut prevented, FWCP)
    - [x] `Fed Flow of Funds - Balance Sheet of Household and Nonprofit Organizations 1952-2021/`: To obtain aggregate household balance sheet data
    - [x] `Fed Flow of Funds - EFA - Household Debt/`: To estimate household debt-to-income ratio
    - [x] `Federal Housing Finance Agency/`: Housing Price Index (HPI) data
    - [x] `FIPS/`: FIPS code, serving as the primary key of all sub-projects
    - [x] `Home Mortgage Disclosure Act/`: HMDA data, for local credit supply data
    - [x] `ICE BofA US Corporate Index/`: aggregate bond price index, for constructing the Bartik instrument to the net worth shock
    - [x] `Land Unavailability/`: Land unavailability index data by [Lutz & Sand (2023)](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3478900), serving as the instrument to housing supply
    - [x] `Local Area Unemployment Statistics/`: LAUS unemployment data, for employment population and rate
    - [x] `Mian Sufi 2014 Tradabilty/`: Strategy of industry classification to tradable, non-tradable, construction, and other. All years code are harmonized.
    - [x] `NAICS/`: NAICS code, we harmonized the different versions to be consistent with [Mian & Sufi (2014)](https://doi.org/10.3982/ECTA10451)
    - [x] `NASDAQ Composite Index/`: aggregate equity asset price, for constructing the Bartik instrument to the net worth shock
    - [x] `National State and County Housing Unit Totals/`: Census Bureau housing and population statistics
    - [x] `Personal Consumption Expenditure/`: BEA state-level consumption
    - [ ] `QCEW County-MSA-CSA Crosswalk/`: Crosswalk of county, MSA and CSA; This is not part of the data release but for users to aggregate the county level data to MSA or CSA levels.
    - [x] `Small Area Income and Poverty Estimates/`: SAIPE data, for family median income and poverty indicators
    - [x] `Survey of Income/`: SOI data by IRS, for constructing the household balance sheet and net worth shock
    - [x] `USDA Educational Attainment for adults/`: for education demographics
    - [x] `Vintage Population Estimates for Demographics/`: Population estimates
    - [x] `Sales Tax/`: County sales tax revenue, taxable consumption, and/or gross sales. These data are collected from state department of revenues, and are used to estimate household consumption of counties
        - [x] `1 Alabama/`
        - [x] `4 Arizona/`
        - [x] `5 Arkansas/`
        - [x] `6 California/`
        - [x] `8 Colorado/`
        - [x] `12 Florida/`
        - [x] `17 Illinois/`
        - [x] `18 Indiana/`
        - [x] `19 Iowa/`
        - [x] `22 Louisiana/`
        - [x] `27 Minnesota/`
        - [x] `29 Missouri/`
        - [x] `31 Nebraska/`
        - [x] `32 Nevada/`
        - [x] `36 New York/`
        - [x] `37 North Carolina/`
        - [x] `38 North Dakota/`
        - [x] `39 Ohio/`
        - [x] `42 Pennsylvania/`
        - [x] `45 South Carolina/`
        - [x] `47 Tennessee/`
        - [x] `49 Utah/`
        - [x] `50 Vermont/`
        - [x] `51 Virginia/`
        - [x] `53 Washington/`
        - [x] `55 Wisconsin/`
        - [x] `56 Wyoming/`

## Some data visualizations

**Figure**: Household leverage ratio (debt/housing wealth) over time

<img src="README.assets/figure_d2h_anime.gif" alt="figure_d2h_anime" style="zoom:80%;" />

**Figure**: Household balance sheet structure over time

<img src="README.assets/figure_h2asset.jpg" alt="figure_h2asset" style="zoom:50%;" />

## License & citation

This project is licensed under the MIT License. Users are welcome to create their own data builds if they need to adjust any underlying assumptions in the data processing. However, if *CountyPlus* is cited in research, all modifications should be explained to adhere to academic ethics. We are not responsible for any errors, bias, or potential data manipulation resulting from such modifications.

Please cite this dataset by:

```tex
@unpublished{
  author       = {Cheng Ding and Tianhao Zhao},
  title        = {Frictions, Net Worth Shocks, and Heterogeneous Impacts},
  note         = {Available at SSRN: \url{https://ssrn.com/abstract=4915272}},
  month        = aug,
  year         = {2024},
}
```
