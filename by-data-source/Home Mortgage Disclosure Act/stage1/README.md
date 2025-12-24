# README

**Strategies**

1. Stage 1: 2002 - 2003
	- Fixed width text files
	- Mid file size, stata can do the job great
	- Whole file read in, process then export
2. Stage 2: 2004 - 2006
	- Same as the first stage, but new variable layout
3. Stage 3: 2007 - 2017
	- CSV files
	- > 26 millions observations in every year, very big
	- Pure stata cannot efficiently handle this
        - And the exported stata file takes 40+ GB for each year --> infeasible
	- IDEA: scan line by line, meanwhile doing aggregation
	- this job can be done by Python or other languages
	- strategy description files may be good
	- NOTE: we need all-record data to include those denied cases
