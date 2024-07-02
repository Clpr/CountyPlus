# README - Michael J/County table

## I. Pipeline

* **Input**: [User:Michael J/County table - Wikipedia](https://en.wikipedia.org/wiki/User:Michael_J/County_table)
    * `geographical.xlsx`
* **Processing files**:
    * `main.do`
* **Output**: 
    * `landareas.dta`
* **Variables**
    * `geo_landarea_km2`: Geographic: land area (km^2)
    * `geo_landarea_mi2`: Geographic: land area (mi^2)
    * `geo_waterarea_km2`: Geographic: water area (km^2)
    * `geo_waterarea_mi2`: Geographic: water area (mi^2)
    * `geo_totalarea_km2`: Geographic: total area (km^2)
    * `geo_totalarea_mi2`: Geographic: total area (mi^2)
    * `geo_latitude`: Geographic: latitude
    * `geo_longitude`: Geographic: longitude

## II. Data download

* Go to [User:Michael J/County table - Wikipedia](https://en.wikipedia.org/wiki/User:Michael_J/County_table)
* Save the big table to an excel file. One trick: copying the HTML `<table>` element directly to excel.

<img src="./data%20source.jpg" alt="data source" style="zoom:80%;" />

* Run `main.do`

## III. Data processing tricks

None