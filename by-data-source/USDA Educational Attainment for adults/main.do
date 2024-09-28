* PROCESS USDA EDUCATIONAL ATTAINMENT DATA FOR MERGING

version 15
clear
cls


import excel using "Education.xlsx", ///
	firstrow cellrange(A4) case(lower) clear


* make: numeric fips
destring federalinformationprocessings, generate(fips)

* collect: attainment counts (2000)
gen usda00_edupop_lesshigh = af
gen usda00_edupop_highonly = highschooldiplomaonly2000
gen usda00_edupop_assoonly = ah
gen usda00_edupop_bachelor = bachelorsdegreeorhigher200

* collect: attainment shares (2000)
gen usda00_edushr_lesshigh = aj
gen usda00_edushr_highonly = ak
gen usda00_edushr_assoonly = al
gen usda00_edushr_bachelor = am

* collect: attainment counts (2008)
gen usda08_edupop_lesshigh = an
gen usda08_edupop_highonly = highschooldiplomaonly20081
gen usda08_edupop_assoonly = ap
gen usda08_edupop_bachelor = aq

* collect: attainment shares (2008)
gen usda08_edushr_lesshigh = ar
gen usda08_edushr_highonly = as
gen usda08_edushr_assoonly = at
gen usda08_edushr_bachelor = au

* collect: attainment counts (2017)
gen usda17_edupop_lesshigh = av
gen usda17_edupop_highonly = highschooldiplomaonly20172
gen usda17_edupop_assoonly = ax
gen usda17_edupop_bachelor = bachelorsdegreeorhigher201

* collect: attainment shares (2017)
gen usda17_edushr_lesshigh = az
gen usda17_edushr_highonly = ba
gen usda17_edushr_assoonly = bb
gen usda17_edushr_bachelor = bc


keep fips usda*


* labelling
foreach t in "00" "08" "17" {
	la var usda`t'_edupop_lesshigh "USDA Edu Attain: adults with less than a high school degree (20`t')"
	la var usda`t'_edupop_highonly "USDA Edu Attain: adults with only a high school degree (20`t')"
	la var usda`t'_edupop_assoonly "USDA Edu Attain: adults with a college/associate degree (20`t')"
	la var usda`t'_edupop_bachelor "USDA Edu Attain: adults with at least a bachelor degree (20`t')"
	la var usda`t'_edushr_lesshigh "USDA Edu Attain: share in adults with less than a high school degree (20`t')"
	la var usda`t'_edushr_highonly "USDA Edu Attain: share in adults with only a high school degree (20`t')"
	la var usda`t'_edushr_assoonly "USDA Edu Attain: share in adults with a college/associate degree (20`t')"
	la var usda`t'_edushr_bachelor "USDA Edu Attain: share in adults with at least a bachelor degree (20`t')"
	
}


mdesc

save "usdaedu.dta", replace


