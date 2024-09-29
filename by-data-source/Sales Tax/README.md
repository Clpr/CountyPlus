# README - Sales tax

* This is a collection of documentations about processing local sales tax data. 
* Each folder named by a state is a single project of processing the state’s tax data. To check the details state by state, please check corresponding folders
* The processed data are filled into Excel files using `template.xlsx`. In each state’s folder:
    * A `README.md` is available which explains essential institutional facts, data processing, and other information
    * A `downloaded files.png` that displays the file names of downloaded tax records. Users who want to exactly align with our data build may check this.
    * Other essential files.

* Then, `main.do` and the programs in folder `scripts/` process these unified Excel files and export Stata data files to `output/` (create it by your own)

## Important disclaimers

We provide detailed instructions on how to legally access these publicly available tax data within the United States. However, NO raw data, which are often in form of PDF files or MS Excel files, have been and will be uploaded to this GitHub repository in order to avoid any potential copyright disputes or violations of local government data disclosure policies.

We understand that local government public data disclosure policies may change over time. If any of the instructions for accessing public tax records documented in this repository become non-compliant at any point in the future, we will remove them upon receiving notification.

## Output files

* **Output**: 
    * `FIPS NAME.dta`: State-specific files
    * `salestax.dta`: The appended file
* **Variables**
    * `output/salestax.dta`:
        * `year`
        * `fips_state`: State 2-digit FIPS
        * `fips_county`: County 3-digit FIPS
        * `state`: State name
        * `county`: County name
        * `tax_amnt`: Sales tax data: origin sales/collection amount records from local gov
        * `tax_unit`: Sales tax data: unit/scale of the original records
        * `tax_rept`: Sales tax data: report types
        * `tax_type`: Sales tax data: collection types
        * `tax_ttpy`: Sales tax data: reporting year type, calendar or fiscal year
        * `tax_rate`: Sales tax data: applied rate in digital, -1 unavailable, -2 unapplicable
        * `tax_rtpy`: Sales tax data: type of the applied rate
        * `tax_shar`: Sales tax data: by-year share/distribution, i.e. c/sum(c)
        * `tax_lshr`: Sales tax data: by-year log share/distribution, i.e. ln(c)/sum(ln(c))
        * `tax_stpgy`: Sales tax data: based on what the by-year share/distribution is computed
