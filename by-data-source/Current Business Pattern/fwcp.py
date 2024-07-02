# ------------------------------------------------------------------------------
# CONSTRUCT FRACTION OF WAGE CUT PREVENTED (FWCP) AS MEASURE FOR DNWR
# SOURCE: `output/big_yyyy.csv`, yyyy = 2003,...2019
# OUTPUT: `output/fwcp.csv`
# ------------------------------------------------------------------------------

import numpy as np
import pandas as pd


# UTILS ------------------------------------------------------------------------
def mkpars(d : pd.DataFrame, lowq : float, highq : float, midq : float):
    _mids = d.groupby('fips')['wg'].quantile(midq).rename('mid').reset_index()
    _lows = d.groupby('fips')['wg'].quantile(lowq).rename('low').reset_index()
    _high = d.groupby('fips')['wg'].quantile(highq).rename('high').reset_index()
    d2 = pd.merge(_mids,_lows, on = 'fips')
    d2 = pd.merge(d2,_high, on = 'fips')
    d2['range'] = d2['high'] - d2['low']
    return d2

def winsor(x : pd.Series, lprob : float, rprob : float) -> pd.Series:
    _lt = x.quantile(lprob)
    _rt = x.quantile(rprob)
    x2 = x.copy()
    x2[x2 < _lt] = _lt
    x2[x2 > _rt] = _rt
    return x2

def mkfwcp(
        t1 : int, 
        t2 : int,
        lwinsor : float = 0.005,
        rwinsor : float = 0.995,
        topgsample : float = 0.75,
        lowq : float = 0.35,
        midq : float = 0.50,
        higq : float = 0.75
) -> pd.DataFrame:
    """Makes FWCP for each county in a given year t1-t2
    returns a dataframe (year, fips, fwcp, p, ptilde).
    some counties may be missing during the process, because of filtering
    """
    T1         = t1
    T2         = t2
    LWINSOR    = lwinsor
    RWINSOR    = rwinsor
    TOPGSAMPLE = topgsample
    LOWQ       = lowq
    HIGQ       = higq
    MIDQ       = midq

    # load
    d1 = pd.read_csv('output/big_' + str(T1) + '.csv', header=0)
    d2 = pd.read_csv('output/big_' + str(T2) + '.csv', header=0)

    # merge, inner join, dropping less than 5% out of 410000+ obs so it is fine
    d = pd.merge(d1,d2,on = ['fipstate','fipscty','naics'], suffixes=['1','2'],how='inner')
    d['fips'] = np.int64(d['fipstate'] * 1000 + d['fipscty'])

    # drop 0-employment obs
    d.drop(d[ (d['emp1'] < 1) | (d['emp2'] < 1) ].index, inplace=True)

    # define weekly nominal wages
    d['w1'] = d['ap1'] / d['emp1'] / 52
    d['w2'] = d['ap2'] / d['emp2'] / 52
    d['wg'] = winsor(d['w2'] / d['w1'] - 1, LWINSOR, RWINSOR)

    # filter top 25% nominal wage growth obs
    dtop = d[d['wg'] >= d['wg'].quantile(TOPGSAMPLE)].copy()

    # params for this subsample (mid, 35 & 75 quantiles)
    dtop = dtop.merge(mkpars(dtop, LOWQ, HIGQ, MIDQ), on = 'fips')

    # construct observations from G(0,1)
    G01 = winsor((dtop['wg'] - dtop['mid']) / (dtop['range']), LWINSOR, RWINSOR)

    # compute FWCP for each county
    di_fwcp = {
        'year'   : [],
        'fips'   : [],
        'fwcp'   : [],
        'p'      : [],
        'ptilde' : []
    }
    for c in d['fips'].unique():
        _dcty = d[d['fips'] == c].copy()
        if _dcty.shape[0] < 2:
            continue
        # county-specific loc & dispersion params
        _par = {
            'mid' : _dcty['wg'].quantile(MIDQ),
            'low' : _dcty['wg'].quantile(LOWQ),
            'hig' : _dcty['wg'].quantile(HIGQ)
        }
        _par['range'] = _par['hig'] - _par['low']
        # transform G(0,1) to county-specific notional distribution
        _Zs = G01 * _par['range'] + _par['mid']
        # p: actual wage cut ratio
        _p  = (_dcty['wg'] < 0).sum() / _dcty.shape[0]
        # ptilde: supposed wage cut ratio
        _pt = (_Zs < 0).sum() / len(_Zs)
        # fwcp
        _fwcp = 1 - _p / (_pt + 1E-8)
        di_fwcp['year'].append(T2)
        di_fwcp['fips'].append(c)
        di_fwcp['fwcp'].append(_fwcp)
        di_fwcp['p'].append(_p)
        di_fwcp['ptilde'].append(_pt)

    return(pd.DataFrame(di_fwcp))



# MAIN -------------------------------------------------------------------------
df = pd.DataFrame()
df = pd.concat(
    [mkfwcp(t,t+1) for t in range(2003,2019)], 
    axis = 0,
    ignore_index = True
)
df.to_csv('output/fwcp04-19.csv', header=True, index = False)












