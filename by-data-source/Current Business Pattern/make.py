# PROCESS CBP COUNTY DATA
# 1. employment by sector
# 2. payroll by sector
# 3. Herfindalh-Hirschman index in each county
# 4. number of establishments

from datatable import dt, f, by, update


# MIAN SUFI (2014) SECTOR INFO AND MAKE MERGE TABLES ---------------------------
ms14 = dt.fread('../Mian Sufi 2014 Tradability/ms14sector.csv')
ms14maps = {
    x : { ms14[i,'naics' + x] : ms14[i,'sector'] for i in range(ms14.shape[0]) }
    for x in ['02','07','12','17','22']
}
ms14chks = {
    2003 : '02',
    2004 : '02',
    2005 : '02',
    2006 : '02',
    2007 : '02',
    2008 : '07',
    2009 : '07',
    2010 : '07',
    2011 : '07',
    2012 : '12',
    2013 : '12',
    2014 : '12',
    2015 : '12',
    2016 : '12',
    2017 : '17',
    2018 : '17',
    2019 : '17'
}


# UTILITIES --------------------------------------------------------------------
diFiles = {
    t : 'original/' + str(t) + '/cbp' + str(t)[-2:] + 'co.txt'
    for t in range(2003,2020)
}

def agghidx(d : dt.Frame) -> dt.Frame:
    """
    aggregates herfinhahl at 4-digit industry level
    """
    _sumemp4digit = d[:, dt.sum(f.emp), by(f.naics)]
    _sumemp4digit.key = 'naics'
    _hid = d[:,:,dt.join(_sumemp4digit)]
    _hid.names = {'emp.0' : 'sumemp'}
    _hid['shr'] = _hid[:,(f.emp / f.sumemp * 100)]
    _hid = _hid[:,dt.sum(dt.math.square(f.shr)),by(f.naics)]
    _hid.names = {'shr' : 'herfindahl'}
    _hid.key = 'naics'
    return _hid

def aggbysec(aggd : dt.Frame, vstr : str) -> dt.Frame:
    """
    aggregates emp, ap, est by sector in counties
    vstr in {emp,ap,est}
    """
    subdts = {
        sec : aggd[f.sector == SEC, ['fips',vstr]]
        for sec,SEC in zip(
            ['tra','non','con','oth'],
            ['tradable','non-tradable','construction','other']
        )
    }
    for k in subdts.keys():
        subdts[k].names = {vstr : vstr + '_' + k}
        subdts[k].key = 'fips'
    # merge
    aggd2 = subdts['tra'][:,:,dt.join(subdts['non'])]
    aggd2 = aggd2[:,:,dt.join(subdts['con'])]
    aggd2 = aggd2[:,:,dt.join(subdts['oth'])]
    aggd2.key = 'fips'
    return aggd2


# PROCESS BY YEAR (COUNTY) -----------------------------------------------------
for t in range(2003,2020):
    print('processing: ' + str(t) + '...')

    _vars2Read = [
        'fipstate', 
        'fipscty', 
        'naics', 
        'emp', # Total Mid-March Employees
        'ap',  # Total Annual Payroll ($1,000)
        'est' # Total Number of Establishments
    ]

    if t == 2015:
        _vars2Read = [x.upper() for x in _vars2Read]
        d = dt.fread(diFiles[t], header = True)[:,_vars2Read]
        d.names = { x : x.lower() for x in _vars2Read }
    else:
        d = dt.fread(diFiles[t], header = True)[:,_vars2Read]

    # keep only 4-digit level industries
    d = d[
        [naics.count('/') == 2 for naics in d.to_dict()['naics']], 
        :
    ]

    # add a full fips column
    d['fips'] = d[:,f.fipstate * 1000 + f.fipscty]

    # strip by drop '/', and make naics code int32 to merge
    d[:, update(naics = f.naics[:4])]
    d['naics'] = dt.int32

    # fill NA with 0 (no data is thought to be no such industry, or masked)
    d[:,int].replace(None, 0)

    # maps to sector info
    d['sector'] = dt.Frame([ 
        ms14maps[ms14chks[t]][x] 
        for x in d.to_dict()['naics'] 
    ])

    # save a big (county,industry) datatable
    d.to_csv('output/big_' + str(t) + '.csv')

    # agg (county,sector): total employment by sector
    _d_agg_emp = d[:, dt.sum(f.emp), by(f.sector,f.fips)]

    # agg (county,sector): total payroll by sector
    _d_agg_ap  = d[:, dt.sum(f.ap) , by(f.sector,f.fips)]

    # agg (county,sector): total number of establishments by sector
    _d_agg_est  = d[:, dt.sum(f.est) , by(f.sector,f.fips)]

    # agg (naics): Herfindalh index by 4-digit industry
    _d_agg_hid = agghidx(d)

    # save herfindalh index
    _d_agg_hid.to_csv('output/hhi' + str(t) + '.csv')

    # agg (county): average Herfindalh index in each county, weighted by employment
    d = d[:,:,dt.join(_d_agg_hid)]
    d_agg_hid = d[
        :,
        dt.sum(f.emp * f.herfindahl) / dt.sum(f.emp),
        by(f.fips)
    ]
    d_agg_hid.names = {'C0' : 'herfindahl'}
    d_agg_hid.key = 'fips'

    # agg (county): total employment/payroll/establishments by sector
    d_agg_emp = aggbysec(_d_agg_emp, 'emp')
    d_agg_ap  = aggbysec(_d_agg_ap , 'ap')
    d_agg_est = aggbysec(_d_agg_est, 'est')

    # merge and save
    dagg = d_agg_emp[:,:,dt.join(d_agg_ap)]
    dagg = dagg[:,:,dt.join(d_agg_hid)]
    dagg = dagg[:,:,dt.join(d_agg_est)]
    dagg['year'] = t

    dagg.to_csv('output/' + str(t) + '.csv')

    print('exported: ' + str(t) + '.csv')



# MERGE (COUNTY) ---------------------------------------------------------------
D = dt.rbind([
    dt.fread('output/' + str(t) + '.csv')
    for t in range(2003,2020)
])
D.to_csv('output/2003-2019.csv')




