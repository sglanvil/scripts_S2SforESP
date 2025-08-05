import xarray as xr
import numpy as np
import glob
import os
import sys
from geocat.comp import interp_hybrid_to_pressure
import re

# --- Get arguments from command line ---
if len(sys.argv) != 5:
    print("Usage: python process_year.py <year> <month> <varname> <varname_out>")
    sys.exit(1)
year = int(sys.argv[1])
month = sys.argv[2]
varname = sys.argv[3]
varname_out = sys.argv[4]

number_match = re.search(r'\d+', varname_out)
if number_match:
    number = int(number_match.group())
    target = number * 100
else:
    raise ValueError(f"No number found in varname_out '{varname_out}' to calculate target.")
srcDir = "/glade/derecho/scratch/sglanvil/holdingCell/E3SM_mapped"
destDir = f"{srcDir}/{varname_out}"
os.makedirs(destDir, exist_ok=True)

file_list = sorted(glob.glob(os.path.join(srcDir, f"mapped_v21.LR.BSMYLEsmbb.{year}-{month}*.eam.h0.{varname}.*.nc")))
for inFile in file_list:
    ds = xr.open_dataset(inFile)
    inFilePS = inFile.replace(f".{varname}.", ".PS.")
    dsPS = xr.open_dataset(inFilePS)
    data = interp_hybrid_to_pressure(
        ds[varname],
        ds['hyam'],
        ds['hybm'],
        dsPS["PS"],
        p0=1e5,
        new_levels=np.array([target]),
        method='linear'
    ).squeeze()
    ds_out = data.to_dataset(name=varname_out)
    outFile = os.path.basename(inFile).replace(f".{varname}.", f".{varname_out}.")
    ds_out.to_netcdf(f"{destDir}/{outFile}")

