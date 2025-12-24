* PROCESS FED FLOW OF FUNDS, HOUSEHOLD & NPO BALANCE SHEET

version 15

import delimited using "original/z1-visualization-data.csv", ///
	clear delim(",") varn(1) case(lower)

* rename vars according to `z1-visualization-dictionary.txt`
{
	rename fl152090005q ffof_nw
	rename fl152090006q ffof_nw2dpi
	rename fl152000005q ffof_asset
	rename fl152000006q ffof_asset2dpi
	rename fl154190005q ffof_liability
	rename fl154190006q ffof_liability2dpi
	rename lm152010005q ffof_nfasset
	rename lm152010006q ffof_nfasset2dpi
	rename fl154090005q ffof_fiasset
	rename fl154090006q ffof_fiasset2dpi
	rename fl153165105q ffof_mortgage
	rename fl153165106q ffof_mortgage2dpi
	rename fl153166000q ffof_credit
	rename fl153166006q ffof_credit2dpi
	rename fl154199005q ffof_othliab
	rename fl154199006q ffof_othliab2dpi
	rename lm155035015q ffof_realestate
	rename lm155035016q ffof_realestate2dpi
	rename lm155111005q ffof_durable
	rename lm155111006q ffof_durable2dpi
	drop lm162010005q
	drop lm162010006q
	rename fl154000025q ffof_deposit
	rename fl154000026q ffof_deposit2dpi
	rename lm153064105q ffof_directequity
	rename lm153064106q ffof_directequity2dpi
	rename lm153064175q ffof_indireequity
	rename lm153064176q ffof_indireequity2dpi
	rename lm154022005q ffof_directdebtsecu
	rename lm154022006q ffof_directdebtsecu2dpi
	rename lm154022075q ffof_indiredebtsecu
	rename lm154022076q ffof_indiredebtsecu2dpi
	drop fl594190045q
	drop fl594190046q
	drop lm152090205q
	drop lm152090206q
	drop fl153099005q
	drop fl153099006q
	drop fc152090005q
	drop fc153064475q
	drop fc154022375q
	drop fc155035005q
	drop fc152090045q
	rename fa156012005q ffof_dpi
}
{
	la var ffof_nw "Net Worth, Millions of dollars, Flow of Funds"
	la var ffof_nw2dpi "Net Worth, as a percentage of disposable personal income (SAAR), Percentage, Flow of Funds"
	la var ffof_asset "Total Assets, Millions of dollars, Flow of Funds"
	la var ffof_asset2dpi "Total Assets, as a percentage of disposable personal income (SAAR), Percentage, Flow of Funds"
	la var ffof_liability "Total Liabilities, Millions of dollars, Flow of Funds"
	la var ffof_liability2dpi "Total Liabilities,, as a percentage of disposable personal income (SAAR), Percentage, Flow of Funds"
	la var ffof_nfasset "Nonfinancial Assets, Millions of dollars, Flow of Funds"
	la var ffof_nfasset2dpi "Household Nonfinancial assets, as a percentage of disposable personal income (SAAR), Percentage, Flow of Funds"
	la var ffof_fiasset "Financial Assets, Millions of dollars, Flow of Funds"
	la var ffof_fiasset2dpi "Financial Assets, as a percentage of disposable personal income (SAAR), Percentage, Flow of Funds"
	la var ffof_mortgage "Home Mortgages, Millions of dollars, Flow of Funds"
	la var ffof_mortgage2dpi "Home Mortgages, as a percentage of disposable personal income (SAAR), Percentage, Flow of Funds"
	la var ffof_credit "Consumer Credit, Millions of dollars, Flow of Funds"
	la var ffof_credit2dpi "Consumer Credit, as a percentage of disposable personal income (SAAR), Percentage, Flow of Funds"
	la var ffof_othliab "Other Liabilities, Millions of dollars, Flow of Funds"
	la var ffof_othliab2dpi "Other Liabilities, as a percentage of disposable personal income (SAAR), Percentage, Flow of Funds"
	la var ffof_realestate "Real Estate, Millions of dollars, Flow of Funds"
	la var ffof_realestate2dpi "Real Estate, as a percentage of disposable personal income (SAAR), Percentage, Flow of Funds"
	la var ffof_durable "Consumer Durables, Millions of dollars, Flow of Funds"
	la var ffof_durable2dpi "Consumer Durables, as a percentage of disposable personal income (SAAR), Percentage, Flow of Funds"
	la var ffof_deposit "Deposits, Millions of dollars, Flow of Funds"
	la var ffof_deposit2dpi "Deposits, as a percentage of disposable personal income (SAAR), Percentage, Flow of Funds"
	la var ffof_directequity "Directly held corporate equities, Millions of dollars, Flow of Funds"
	la var ffof_directequity2dpi "Directly held corporate equities as a percentage of disposable personal income (SAAR), Percentage, Flow of Funds"
	la var ffof_indireequity "Indirectly held corporate equities, Millions of dollars, Flow of Funds"
	la var ffof_indireequity2dpi "Indirectly held corporate equities, as a percentage of disposable personal income (SAAR), Percentage, Flow of Funds"
	la var ffof_directdebtsecu "Directly held debt securities, Millions of dollars, Flow of Funds"
	la var ffof_directdebtsecu2dpi "Directly held debt securities as a percentage of disposable personal income, Percentage, Flow of Funds"
	la var ffof_indiredebtsecu "Indirectly held debt securities, Millions of dollars, Flow of Funds"
	la var ffof_indiredebtsecu2dpi "Indirectly held debt securities as a percentage of disposable personal income, Percentage, Flow of Funds"
	la var ffof_dpi "Disposable Personal Income (DPI), Millions of dollars, Flow of Funds"

}


* process date
gen year = substr(date, 1,4)
destring year, replace

foreach var of varlist ffof_* {
	bysort year: egen _tmp  = mean(`var')
	replace `var' = _tmp
	drop _tmp
}

keep year ffof_*
duplicates drop
sort year

save "ffof_hhnpo.dta", replace





