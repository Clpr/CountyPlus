# README - Federal Information Processing Standard (FIPS)

## I. Pipeline

* **Input**: [transition.fcc.gov/oet/info/maps/census/fips/fips.txt](https://transition.fcc.gov/oet/info/maps/census/fips/fips.txt)
    * `fips.txt`
* **Processing files**:
    * `make.do`
* **Output**: 
    * `fips_county.dta`
        * `fips_state`: FIPS of state
        * `fips_county`: 3-digit county FIPS
        * `county_name`: County name
        * `state_abbr`: Abbreviation of US states
        * `fips`: 5-digit county FIPS
    * `fips_state.dta`
        * `state_name`
        * `state_abbr`
        * `fips_state`
* **Variables**
    * `fips_county.dta`
        * `fips_state`: FIPS of state
        * `fips_county`: 3-digit county FIPS
        * `county_name`: County name
        * `state_abbr`: Abbreviation of US states
        * `fips`: 5-digit county FIPS
    * `fips_state.dta`
        * `state_name`
        * `state_abbr`
        * `fips_state`

## II. Data download

There are various sources of FIPS code. We use version by FCC. Users may also check Census Bureau or directly visit [Search | CSRC (nist.gov)](https://csrc.nist.gov/publications/fips). These data sources should give the same results.

Because FIPS code serves as the primary key of the whole dataset, users may use the CSV files shipping with _CountyPlus_ for better replicability.

## IV. Directory tree

Here is our directory tree for reference:

```cmd
D:.
│   fips_county.dta
│   fips_state.dta
│   make.do
│   README.md
│
└───original
        fips_county.csv
        fips_state.csv
```

