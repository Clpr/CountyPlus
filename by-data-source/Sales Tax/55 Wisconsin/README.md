# README

1. Data source: [DOR County Sales Tax Distributions (wi.gov)](https://www.revenue.wi.gov/Pages/RA/CountySalesTaxDistributions.aspx)
2. The current state sales tax rate is 5% since 1982
3. Wisconsin DoR report their county sales tax distribution in excel since 2013. Previous years data are available from an interactive table. Search "Reports" on WI DoR website by setting Category as "Taxex, Sales", and find "County Sales Tax Distributions - Interactive Data". Data are available by county (one by one)
4. In the interactive table, choose "Monthly County Sales Tax Distributions by County (1986-2021)" and set filter to be "(All)", then we can get a big matrix (date, county). Download it and reshape

5. Wisconsin reports sales tax revenues but not tax bases. So we might need to adjust it by county-level sales tax rates

6. Some counties did not have sales tax until specific years (or always no sales tax). These counties are interpolated by the following rules: if all years are missing, then interpolate with state average; if not all years are missing, then interpolate with state average then scale such an average to the same level as this specific county revenue using a scaling factor. The scaling factor is defined as: suppose this county has only 3 data points, then compute the ratio between 3-year state average and the average of the 3 data points. Please check "55 Wisconsin.xlsx" at "step3 - interpolate" worksheet for more details.

<img src="data%20source%201.png" alt="data source 1" style="zoom:75%;" />