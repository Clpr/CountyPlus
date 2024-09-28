/*******************************************************************************
PROCESS SALES DATA
Stata 18
Sep 26, 2023
*******************************************************************************/

clear
cls


qui do "scripts/1 Alabama.do"

qui do "scripts/4 Arizona.do"

qui do "scripts/5 Arkansas.do"

qui do "scripts/6 California.do"

qui do "scripts/8 Colorado.do"

qui do "scripts/12 Florida.do"

qui do "scripts/17 Illinois.do"

qui do "scripts/18 Indiana.do"

qui do "scripts/19 Iowa.do"

qui do "scripts/22 Louisiana.do"

qui do "scripts/27 Minnesota.do"

qui do "scripts/29 Missouri.do"

qui do "scripts/31 Nebraska.do"

qui do "scripts/32 Nevada.do"

qui do "scripts/36 New York.do"

qui do "scripts/37 North Carolina.do"

qui do "scripts/38 North Dakota.do"

qui do "scripts/39 Ohio.do"

qui do "scripts/42 Pennsylvania.do"

qui do "scripts/45 South Carolina.do"

qui do "scripts/47 Tennessee.do"

qui do "scripts/49 Utah.do"

qui do "scripts/50 Vermont.do"

qui do "scripts/51 Virginia.do"

qui do "scripts/53 Washington.do"

qui do "scripts/55 Wisconsin.do"

qui do "scripts/56 Wyoming.do"


clear
append using ///
	"output/1 Alabama.dta     " ///
	"output/12 Florida.dta    " ///
	"output/17 Illinois.dta   " ///
	"output/18 Indiana.dta    " ///
	"output/19 Iowa.dta       " ///
	"output/22 Louisiana.dta  " ///
	"output/27 Minnesota.dta  " ///
	"output/29 Missouri.dta   " ///
	"output/31 Nebraska.dta   " ///
	"output/32 Nevada.dta     " ///
	"output/36 New York.dta   " ///
	"output/37 North Carolina.dta" ///
	"output/38 North Dakota.dta" ///
	"output/39 Ohio.dta       " ///
	"output/42 Pennsylvania.dta" ///
	"output/45 South Carolina.dta" ///
	"output/47 Tennessee.dta  " ///
	"output/49 Utah.dta       " ///
	"output/5 Arkansas.dta    " ///
	"output/50 Vermont.dta    " ///
	"output/51 Virginia.dta   " ///
	"output/53 Washington.dta " ///
	"output/55 Wisconsin.dta  " ///
	"output/56 Wyoming.dta    " ///
	"output/6 California.dta  " ///
	"output/8 Colorado.dta   "


tab year
mdesc


save "output/salestax.dta", replace
