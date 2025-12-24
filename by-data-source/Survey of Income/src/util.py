# utilities

from pydoc import locate # to convert string-stored type to type object
from typing import List, Dict
import zipfile, os
import pandas as pd

# ------------------------------------------------------------------------------
def unzip(fpath: str, outdir: str = './'):
    """unzips a given zip file and return a list of paths of all unzipped files
    """
    if not fpath.endswith('.zip'):
        raise ValueError("not a zip")
    # unzip
    with zipfile.ZipFile(fpath, 'r') as zip_ref:
        ls_files = zip_ref.namelist()
        zip_ref.extractall(outdir)
    return [os.path.join(outdir,x) for x in ls_files]


# ------------------------------------------------------------------------------
def proc_year_until2009(optyear: dict, cols: list, coldtypes: Dict[str,str]):
    """process until-2009 SOI data, returns a dataframe
    will not delete unzipped files for quick dev, so pls use a separate folder
    e.g. `sandbox/` to unload xls files
    """
    xlsfiles = unzip(optyear['zipfile'], outdir = 'sandbox/')
    df = pd.DataFrame()
    print(optyear['year'])
    for fpath in xlsfiles:
        if not fpath.endswith('.xls'):
            continue
        print(f'\t{fpath}')
        df = df.append(pd.read_excel(
            fpath, 
            header  = optyear['header'] - 1, 
            usecols = optyear['colrange'],
            names   = cols,
            skipfooter = optyear['skipfooter'],
            dtype      = {x[0] : locate(x[1]) for x in coldtypes.items()},
            na_values  = 'd'
        ))
    df['year'] = optyear['year']
    return df

# ------------------------------------------------------------------------------
def proc_year_since2010(optyear: dict, cols: list, coldtypes: Dict[str,str]):
    """process after-2009 SOI data, returns a dataframe
    will not delete unzipped files for quick dev, so pls use a separate folder
    e.g. `sandbox/` to unload xls files
    """
    xlsfiles = unzip(optyear['zipfile'], outdir = 'sandbox/')
    df = pd.DataFrame()
    print(optyear['year'])
    for fpath in xlsfiles:
        if fpath.endswith(optyear['collected table']):
            print(f'\t{fpath}')
            df = df.append(pd.read_excel(
                fpath,
                header  = optyear['header'] - 1, 
                usecols = optyear['colrange'],
                names   = cols,
                skipfooter = optyear['skipfooter'],
                dtype      = {x[0] : locate(x[1]) for x in coldtypes.items()},
                na_values  = ['d','(1)','-1']
            ))
    df['year'] = optyear['year']
    return df



