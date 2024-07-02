# CLEAN NAICS CODING DATA
# py 3.9.6
"""
NOTES:
1. code `31-33` for manufactures cannot be converted to int directly.
2. similarly, `44-45` for retail trade, `48-49` for transportation
3. 2007 code as primary key across years, consistent with Mian Sufi (2014)
"""

import pandas as pd
import numpy as np
import re

# data files
fstr02 = 'original/2002/naics_2_6_02.txt'
fstr07 = 'original/2007/naics07.xls'
fstr12 = 'original/2012/2-digit_2012_Codes.xls'
fstr17 = 'original/2017/2-6 digit_2017_Codes.xlsx'
fstr22 = 'original/2022/2-6 digit_2022_Codes.xlsx'

# 2002 -------------------------------------------------------------------------

def proc02(fstr, yearstr) -> pd.DataFrame:
    d = pd.read_fwf(
        fstr02, 
        widths = [8, 119], 
        skiprows = 8, 
        header = None
    )
    d.rename(columns = {0 : '_naics', 1 : '_ind'}, inplace = True)
    def _filter(x):
        if isinstance(x, int):
            return 999 < x < 10000
        elif isinstance(x, str):
            flag1 = (len(x.strip()) == 4)
            flag2 = (x.strip() not in {'31-33','44-45','48-49'})
            return flag1 & flag2
        else:
            return False
    d = d[[ _filter(x) for x in d['_naics'] ]]
    d['naics' + yearstr] = [int(x) for x in d['_naics']]
    d['ind' + yearstr] = [str(x).strip() for x in d['_ind']]
    d.drop(['_naics','_ind'], axis = 1, inplace = True)
    d.reset_index(drop = True, inplace = True)
    d.to_csv('naics' + yearstr + '_4digit.csv', index = False, header = True)
    return d

# 2007-2022 --------------------------------------------------------------------

def proc07to22(fstr, yearstr) -> pd.DataFrame:
    d = pd.read_excel(
    fstr,
    skiprows= 2,
    header = None,
    usecols = 'A:C'
    )
    d.rename(columns = {0 : 'id', 1 : '_naics', 2 : '_ind'}, inplace = True)
    def _filter(x):
        if isinstance(x, int):
            return 999 < x < 10000
        elif isinstance(x, str):
            flag1 = (len(x.strip()) == 4)
            flag2 = (x.strip() not in {'31-33','44-45','48-49'})
            return flag1 & flag2
        else:
            return False
    d = d[[ _filter(x) for x in d['_naics'] ]]
    d['naics' + yearstr] = [int(x) for x in d['_naics']]
    d['ind' + yearstr] = [str(x).strip() for x in d['_ind']]
    d.drop(['id','_naics','_ind'], axis = 1, inplace = True)
    d.reset_index(drop = True, inplace = True)
    d.to_csv('naics' + yearstr + '_4digit.csv', index = False, header = True)
    return d


# PROC BY YEAR -----------------------------------------------------------------
d02 = proc02(fstr02, '02')
d07 = proc07to22(fstr07, '07')
d12 = proc07to22(fstr12, '12')
d17 = proc07to22(fstr17, '17')
d22 = proc07to22(fstr22, '22')


# MERGE ------------------------------------------------------------------------
# NOTES: 2007 code as primary key, only consider 07-existing industries
_df = pd.merge(d07, d02, left_on = 'naics07', right_on = 'naics02',how ='outer')
_df = pd.merge(_df, d12, left_on = 'naics07', right_on = 'naics12',how ='outer')
_df = pd.merge(_df, d17, left_on = 'naics07', right_on = 'naics17',how ='outer')
_df = pd.merge(_df, d22, left_on = 'naics07', right_on = 'naics22',how ='outer')
for ystr in ['02','07','12','17','22']:
    _df['naics' + ystr].fillna(-1, inplace = True)
    _df['naics' + ystr] = _df['naics' + ystr].astype(int)

# ABSORBED BY 2007 -------------------------------------------------------------
m02 = {
    5161 : 5191,
    5173 : 5179,
    5175 : 5171,
    5181 : 5179
}
m12 = {
    7225 : 7221
}
m17 = {
    5173 : 5179,
    7225 : 7221,
    4522 : 4521,
    4523 : 4521
}
m22 = {
    5161 : 5191,
    7225 : 7221,
    4491 : 4421,
    4492 : 4431,
    4551 : 4521,
    4552 : 4521,
    4561 : 4461,
    4571 : 4471,
    4572 : 4543,
    4581 : 4481,
    4582 : 4482,
    4583 : 4483,
    4591 : 4511,
    4592 : 4512,
    4593 : 4531,
    4594 : 4532,
    4595 : 4533,
    4599 : 4539,
    5131 : 5111,
    5132 : 5112,
    5162 : 5151,
    5178 : 5179,
    5192 : 5191
}

naics = _df['naics07'].copy()
for k,v in m02.items():
    naics[_df['naics02'] == k] = v
for k,v in m12.items():
    naics[_df['naics12'] == k] = v
for k,v in m17.items():
    naics[_df['naics17'] == k] = v
for k,v in m22.items():
    naics[_df['naics22'] == k] = v
_df['naics'] = naics


# SAVE -------------------------------------------------------------
_df.to_csv('naics_4digit_07key.csv', header = True, index = False)

