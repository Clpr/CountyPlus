# CountyPlus

> Last update: July 02, 2024

**(This project is still updating. More contents on the way...)**

*CountyPlus* dataset is a county-level panel dataset for economic research. It consists of 3000+ U.S. counties years from 2003 to 2019 while covering a broad collection of county-scope variables: 

- County geographic and demographic characteristics
- Household balance sheets e.g. holdings by asset type
- Household net worth shocks and a Bartik instrument
- Household income and consumption
- Local sales tax and taxable consumption
- Local labor market indicators such as wage and employment
- Local house market indicators such as house price and house ownership
- Local credit supply, mainly about home mortgage loans
- Local industry size, payroll and diversity
- Indicators of local economic frictions: collateral constraint, and downward nominal wage rigidity (DNWR)

The dataset uses all public available data sources for the best replicability. This GitHub repo provides detailed data documentation for *CountyPlus* dataset including:

- By data source cleaning instructions, institutional facts, explanation, and programming code
- Documentations and programs for merging to get the final dataset

One can replicate the whole dataset and every sub-project following the instruction and using program files. For now, we do not provide the download of cleaned Stata file (about 36 MB) on GitHub due to some data policy restriction. But please feel free to contact us to request a copy. 

On the current stage, we are actively extending the dataset to cover more variables and time periods. If you have some questions, comments on this dataset, or would like to see some new variables related to your research, you are more than welcome to contact us. We very appreciate your valuable comments.

The rest of this README introduces how this repo is organized. A data dictionary is available as a csv file: [data_dictionary.csv](“./data_dictionary.csv")

## Repo structure

This repo has two main folders:

- `by-data-source/`: this directory saves the documentation by data source and corresponding program files. The output of these “sub-projects” are used in the data merging.
- `src/`: this directory saves the Stata do-files that merge the outputs of the sub-projects, after-merge process, and export the final `CountyPlus.dta` dataset. One may use `main.do` to call the whole pipeline.

## Citation

Please cite this dataset by:

```tex
@Article{DingZhao2024Nonlinear,
  author  = {Cheng, Ding and Zhao, Tianhao},
  journal = {Working paper},
  title   = {Nonlinear Heterogeneous Impact of Net Worth Shocks},
  year    = {2024},
}
```
