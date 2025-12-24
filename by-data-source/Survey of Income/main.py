# ==============================================================================
# EXTRACT, ORGANIZE AND CLEAN IRS SURVEY OF INCOME (SOI) DATA, 2003-2012

# Procedures:
#     1. unzip all files given a year
#     2. if it is before-2011 data, then process by state (.xls)
#     3. otherwise, directly work on the aligned (.csv) files
#     4. append years and save


# ==============================================================================
import src.util as su
import json

# load options
with open("option.json", 'r') as fp:
    options: dict = json.load(fp)


# 2003-2009 tax year data
li_df0309 = [
    su.proc_year_until2009(
        options[str(t)], 
        options['colnames until 2009'], 
        options['dtype until 2009']
    )
    for t in range(2003,2010)
]
df0309 = su.pd.concat(li_df0309)
df0309.to_csv('output/soi0309.csv', index = False)


# 2010-2012 tax year data
li_df1012 = [
    su.proc_year_since2010(
        options[str(t)], 
        options[str(t)]['colnames'], 
        options[str(t)]['dtype']
    )
    for t in range(2010,2013)
]
df1012 = su.pd.concat(li_df1012)
df1012.to_csv('output/soi1012.csv', index = False)

df0312 = su.pd.concat([df0309,df1012])
df0312.to_csv('output/soi0312.csv', index = False)




