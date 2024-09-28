* CLEAN LAUS DATA SET FOR UNEMPLOYMENT AND POVERTY

{
	version 15
	
	*---------------------------------------------------------------------------
	foreach t of numlist 2003(1)2019 {
	//local t = 2004
		import excel using "original/laucnty`t'.xlsx", ///
			firstrow cellrange(A5) case(preserve) clear
		drop if missing(Year)
		
		rename B          fips_state
		rename C          fips_county
		rename Year       year
		rename Force      labor_force
		rename Employed   emp_popu
		rename Unemployed unemp_popu
		rename J          unemp_rate
		
		keep fips_state fips_county year labor_force emp_popu unemp_popu unemp_rate
		
		destring fips_state, replace force
		destring fips_county, replace force
		destring year, replace force
		destring labor_force, replace force
		destring emp_popu, replace force
		destring unemp_popu, replace force
		destring unemp_rate, replace force
		
		la var labor_force "Labor force population, LAUS"
		la var emp_popu    "Employed population, LAUS"
		la var unemp_rate  "Unemployment rate in pct, LAUS"
		la var unemp_popu  "Unemployed population, LAUS"
		
		save "_tmp`t'.dta", replace
	}
	* append
	clear
	foreach t of numlist 2003(1)2019 {
		disp `t'
		append using "_tmp`t'.dta"
		erase "_tmp`t'.dta"
		
		drop if fips_state > 56
		drop if missing(fips_state) | missing(fips_county) | (fips_county == 0)
	}
	
	
	* make fips
	gen long fips = floor(fips_state * 1000 + fips_county)
	
	save "laus.dta", replace
	
	
	
}














