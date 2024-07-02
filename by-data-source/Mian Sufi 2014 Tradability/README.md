# README - Mian & Sufi (2014) industry classification

## I. Pipeline

* **Input**: 
    * `unemployment_miansufi_emtra_final_appendix.pdf`: Appendix of Mian & Sufi (2014), available at [Amir Sufi’s personal website](https://amirsufi.net/data-and-appendices/unemployment_miansufi_emtra_final_appendix.pdf)
    * `../NAICS/naics_4digit_07key.csv`: Harmonized NAICS code across years; output of another data source. Check `by-data-source/NAICS/` of this GitHub project.
* **Processing files**:
    * `make.py`
* **Output**: 
    * `ms14sector.csv`
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

* Use some tools such as Adobe Acrobat, or manually type the table in the Mian & Sufi (2014) appendix PDF file. Save it as a txt file. We uploaded a copy of the txt file to GitHub.
* Run the `../NAICS/` sub-project.

## III. Data processing tricks

- Mian & Sufi (2014) uses 2007 version NAICS code. We extend their definition to all years by harmonizing the different versions of NAICS code
- All industries that are not defined in 2007 (no matter a new industry, or split from an old larger industry) are “absorbed” by 2007 codes. Check the `../NAICS/` sub-project for more details.

## IV. Reference

- Mian, A., & Sufi, A. (2014). What explains the 2007–2009 drop in employment?. *Econometrica*, *82*(6), 2197-2223.