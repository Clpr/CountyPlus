# READM

These zip files are downloaded from IRS Survey of Income (SOI) on Sep 9, 2021. However, to automate the processing, some specific year’s data were manually modified to avoid type errors. The original version and bug-fixed version are both kept for comparison.

The affected files are:

1. 2007
   1. Alaska07ci.xls
   2. Louisiana07ci.xls
   3. Actually, it is because in these two files, the column of county names, esp. which have long county names, got characters in the next column (number of returns, which is numeric). This fails to read the number of returns as numeric. We deleted these out-of-bound characters and moved them back to county name columns.
2. 2008 & 2009
   1. county income 2008 HI.xls
   2. county income 2008 TX.xls
   3. county income 2009 HI.xls
   4. county income 2009 TX.xls
   5. county income 2009 KS.xls
   6. There are extra endnotes lines in these files. we drop one of it to align with other files
