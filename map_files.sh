#!/bin/bash
#PBS -N regridE3SM 
#PBS -A CESM0020 
#PBS -l select=1:ncpus=1:mem=30GB
#PBS -l walltime=00:10:00
#PBS -k eod
#PBS -j oe
#PBS -q casper

module load nco

srcDir=/glade/campaign/cgd/ccr/E3SMv2.1-SMYLEsmbb/archive/M${imonth}/
#srcDir=/glade/campaign/cgd/ccr/E3SMv2.1-SMYLE/archive/
destDir=/glade/derecho/scratch/sglanvil/holdingCell/E3SM_mapped/
weightFile=/glade/work/strandwg/E3SM_regridding/maps/map_ne30pg2_to_0.9x1.25_aave.20230801.nc

inFile=$(ls ${srcDir}/v21.LR.BSMYLEsmbb.${iyear}-${imonth}.${imbr}/atm/proc/tseries/month_1/*eam.h0.${ivar}.*)
#inFile=$(ls ${srcDir}/v21.LR.BSMYLE.${iyear}-${imonth}.${imbr}/atm/proc/tseries/month_1/*eam.h0.${ivar}.*)
echo ${inFile}

filename=$(basename $inFile)
#modifiedFilename="${filename/BSMYLE/BSMYLEsmbb}"
#mappedFile=${destDir}/mapped_${modifiedFilename}
mappedFile=${destDir}/mapped_${filename}
echo ${mappedFile}

ncremap -m ${weightFile} -in ${inFile} ${mappedFile}
echo

exit

