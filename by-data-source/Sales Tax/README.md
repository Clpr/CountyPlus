# README - Sales tax

* This is a collection of processing state-specific sales tax data. 
* Each folder is a single small project of processing the corresponding state’s tax data. The processed data are uniformly filled into Excel files using `template.xlsx`
* Then, `main.do` and the programs in folder `scripts/` process these unified Excel files and export Stata data files to `output/` (create it by your own)
* To check institutional details state by state, check corresponding folders

> ==NOTE==:
>
> 1. All original data are not provided here (but we explain in detail how to locate the original tax records). They are usually digital or scanned PDF, or sometimes Excel files
> 2. In many states, automatic data extraction is unavailable. We *manually* extract data from digital and scanned PDF files with the help of OCR technology
> 3. Because the frequent changes of local government website, some data may be moved, removed or updated without prediction. Our instruction of accessing the original tax records may be out of date. If this happens, then:
>     1. Firstly, check the public archive or library service of the state. Most states archive their out-of-date publications as scanned PDF there
>     2. Then, check the National Archive in which some states archive their public records
>     3. Also, try directly accessing some files by finding the naming rule of files. Some old files may still saved on the local government’s server
>     4. Please let us know if all these methods do not work.

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
