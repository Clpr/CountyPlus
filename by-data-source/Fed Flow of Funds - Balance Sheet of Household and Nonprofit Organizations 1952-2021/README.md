# README - Fed Flow of Funds, Balance sheet of Household and Non-profit organizations

## I. Pipeline

* **Input**: [The Fed - Table: Balance Sheet of Households and Nonprofit Organizations, 1952 - 2022 (federalreserve.gov)](https://www.federalreserve.gov/releases/z1/dataviz/z1/balance_sheet/table/)
    * `z1-visualization-data.csv`
    * `z1-visualizaiton-dictionary`
* **Processing files**:
    * `make.do`
* **Output**: 
    * `ffof_hhnpo.dta`
* **Variables**
    * `ffof_nw`: Net Worth, Millions of dollars, Flow of Funds
    * `ffof_nw2dpi`: Net Worth, as a percentage of disposable personal income (SAAR), Percentage
    * `ffof_asset`: Total Assets, Millions of dollars, Flow of Funds
    * `ffof_asset2dpi`: Total Assets, as a percentage of disposable personal income (SAAR), Percentage
    * `ffof_liability`: Total Liabilities, Millions of dollars, Flow of Funds
    * `ffof_liability2dpi`: Total Liabilities,, as a percentage of disposable personal income (SAAR), Percentage
    * `ffof_nfasset`: Nonfinancial Assets, Millions of dollars, Flow of Funds
    * `ffof_nfasset2dpi`: Household Nonfinancial assets, as a percentage of disposable personal income (SAAR)
    * `ffof_fiasset`: Financial Assets, Millions of dollars, Flow of Funds
    * `ffof_fiasset2dpi`: Financial Assets, as a percentage of disposable personal income (SAAR), Percentage
    * `ffof_mortgage`: Home Mortgages, Millions of dollars, Flow of Funds
    * `ffof_mortgage2dpi`: Home Mortgages, as a percentage of disposable personal income (SAAR), Percentage
    * `ffof_credit`: Consumer Credit, Millions of dollars, Flow of Funds
    * `ffof_credit2dpi`: Consumer Credit, as a percentage of disposable personal income (SAAR), Percentage
    * `ffof_othliab`: Other Liabilities, Millions of dollars, Flow of Funds
    * `ffof_othliab2dpi`: Other Liabilities, as a percentage of disposable personal income (SAAR), Percentage
    * `ffof_realestate`: Real Estate, Millions of dollars, Flow of Funds
    * `ffof_realestate2dpi`: Real Estate, as a percentage of disposable personal income (SAAR), Percentage
    * `ffof_durable`: Consumer Durables, Millions of dollars, Flow of Funds
    * `ffof_durable2dpi`: Consumer Durables, as a percentage of disposable personal income (SAAR), Percentage
    * `ffof_deposit`: Deposits, Millions of dollars, Flow of Funds
    * `ffof_deposit2dpi`: Deposits, as a percentage of disposable personal income (SAAR), Percentage
    * `ffof_directequity`: Directly held corporate equities, Millions of dollars, Flow of Funds
    * `ffof_directequity2dpi`: Directly held corporate equities as a percentage of disposable personal income (SAAR), Percentage
    * `ffof_indireequity`: Indirectly held corporate equities, Millions of dollars, Flow of Funds
    * `ffof_indireequity2dpi`: Indirectly held corporate equities, as a percentage of disposable personal income (SAAR), Percentage
    * `ffof_directdebtsecu`: Directly held debt securities, Millions of dollars, Flow of Funds
    * `ffof_directdebtsecu2dpi`: Directly held debt securities as a percentage of disposable personal income, Percentage
    * `ffof_indiredebtsecu`: Indirectly held debt securities, Millions of dollars, Flow of Funds
    * `ffof_indiredebtsecu2dpi`: Indirectly held debt securities as a percentage of disposable personal income, Percentage
    * `ffof_dpi`: Disposable Personal Income (DPI), Millions of dollars, Flow of Funds

## II. Data download

<img src="./data%20source.jpg" alt="data source" style="zoom:50%;" />

* Data source: [The Fed - Table: Balance Sheet of Households and Nonprofit Organizations, 1952 - 2022 (federalreserve.gov)](https://www.federalreserve.gov/releases/z1/dataviz/z1/balance_sheet/table/)
    * Go to “Household Balance Sheet”
    * Download “Full CSV” as a zip file `z1-visualization.zip`
    * Unzip `z1-visualization-data.csv` and run `make.do`
* Quarterly data, use annual average
* Check `z1-visualization-dictionary.txt` that is unzipped from the archive to see code list. We manually create a `crosswalk.xlsx` to do the variable mapping. This Excel file is uploaded to the GitHub. The cleaned code list is listed below:

| variable      | definition                                                   | unit                |
| ------------- | ------------------------------------------------------------ | ------------------- |
| FL152090005.Q | Net Worth                                                    | Millions of dollars |
| FL152090006.Q | Net Worth, as a percentage of disposable personal income (SAAR) | Percentage          |
| FL152000005.Q | Total Assets                                                 | Millions of dollars |
| FL152000006.Q | Total Assets, as a percentage of disposable personal income (SAAR) | Percentage          |
| FL154190005.Q | Total Liabilities                                            | Millions of dollars |
| FL154190006.Q | Total Liabilities,, as a percentage of disposable personal income (SAAR) | Percentage          |
| LM152010005.Q | Nonfinancial Assets                                          | Millions of dollars |
| LM152010006.Q | Household Nonfinancial assets, as a percentage of disposable personal   income (SAAR) | Percentage          |
| FL154090005.Q | Financial Assets                                             | Millions of dollars |
| FL154090006.Q | Financial Assets, as a percentage of disposable personal income (SAAR) | Percentage          |
| FL153165105.Q | Home Mortgages                                               | Millions of dollars |
| FL153165106.Q | Home Mortgages, as a percentage of disposable personal income (SAAR) | Percentage          |
| FL153166000.Q | Consumer Credit                                              | Millions of dollars |
| FL153166006.Q | Consumer Credit, as a percentage of disposable personal income (SAAR) | Percentage          |
| FL154199005.Q | Other Liabilities                                            | Millions of dollars |
| FL154199006.Q | Other Liabilities, as a percentage of disposable personal income (SAAR) | Percentage          |
| LM155035015.Q | Real Estate                                                  | Millions of dollars |
| LM155035016.Q | Real Estate, as a percentage of disposable personal income (SAAR) | Percentage          |
| LM155111005.Q | Consumer Durables                                            | Millions of dollars |
| LM155111006.Q | Consumer Durables, as a percentage of disposable personal income (SAAR) | Percentage          |
| LM162010005.Q | Nonfinancial Assets                                          | Millions of dollars |
| LM162010006.Q | Nonfinancial Assets, as a percentage of disposable personal income (SAAR) | Percentage          |
| FL154000025.Q | Deposits                                                     | Millions of dollars |
| FL154000026.Q | Deposits, as a percentage of disposable personal income (SAAR) | Percentage          |
| LM153064105.Q | Directly held corporate equities                             | Millions of dollars |
| LM153064106.Q | Directly held corporate equities as a percentage of disposable personal   income (SAAR) | Percentage          |
| LM153064175.Q | Indirectly held corporate equities                           | Millions of dollars |
| LM153064176.Q | Indirectly held corporate equities, as a percentage of disposable   personal income (SAAR) | Percentage          |
| LM154022005.Q | Directly held debt securities                                | Millions of dollars |
| LM154022006.Q | Directly held debt securities as a percentage of disposable personal   income | Percentage          |
| LM154022075.Q | Indirectly held debt securities                              | Millions of dollars |
| LM154022076.Q | Indirectly held debt securities as a percentage of disposable personal   income | Percentage          |
| FL594190045.Q | Household defined benefit pension entitlements               | Millions of dollars |
| FL594190046.Q | Household defined benefit pension entitlements, as a percentage of   disposable personal income (SAAR) | Percentage          |
| LM152090205.Q | proprietors' equity in noncorporate business                 | Millions of dollars |
| LM152090206.Q | proprietors' equity in noncorporate business, as a percentage of   disposable personal income (SAAR) | Percentage          |
| FL153099005.Q | Other financial assets                                       | Millions of dollars |
| FL153099006.Q | Other financial assets, as a percentage of disposable personal income   (SAAR) | Percentage          |
| FC152090005.Q | Net Worth; Change in unadjusted level                        | Millions of dollars |
| FC153064475.Q | Direct and indirect holdings of corporate equity; Change in unadjusted   level | Millions of dollars |
| FC154022375.Q | Directly and indirectly held debt securities; Change in unadjusted level | Millions of dollars |
| FC155035005.Q | Real estate; Change in unadjusted level                      | Millions of dollars |
| FC152090045.Q | other components of net worth, excluding real estate and direct and   indirect holding holdings of corporate equities and debt securities; Change   in unadjusted level | Millions of dollars |
| FA156012005.Q | Disposable Personal Income (DPI)                             | Millions of dollars |


## III. Data processing tricks

None.

## IV. Directory tree

Here is our directory tree for reference:

```cmd
D:.
│   crosswalk.xlsx
│   ffof_hhnpo.dta
│   make.do
│   README.md
│
└───original
        z1-visualization-data.csv
        z1-visualization-dictionary.txt
```

