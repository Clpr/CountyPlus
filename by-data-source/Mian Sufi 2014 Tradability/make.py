# py 3.9.6
# PROCESS SECTOR CLASSIFICATION BY MIAN SUFI (2014)

import re
import pandas as pd

# MIAN SUFI (2014) -------------------------------------------------------------
li = []
with open('unemployment_miansufi_emtra_final_appendix.txt','r') as fp:
    li = fp.readlines()
fp.close()
_trash = li.pop(0)
di = {
    'naics'  : [], # NAICS code
    'sector' : []  # sector
}
for x in li:
    di['naics'].append(int(x[:4]))
    di['sector'].append(re.findall(r'\b[a-zA-Z-]+\b', x[4:])[-1].strip())
df_ms = pd.DataFrame(di)


# MERGE WITH NAICS -------------------------------------------------------------
df_naics = pd.read_csv('../NAICS/naics_4digit_07key.csv', header = 0)
df = pd.merge(df_ms, df_naics, on = 'naics')
df.to_csv('ms14sector.csv', header = True, index = False)
