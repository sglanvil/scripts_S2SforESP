#!/bin/bash
#PBS -N hybrid2press
#PBS -A CESM0020 
#PBS -l select=1:ncpus=1:mem=30GB
#PBS -l walltime=02:00:00
#PBS -j oe
#PBS -q casper

module load conda
conda activate npl

echo "Processing year $YEAR with month=$MONTH varname=$VARNAME → $VARNAME_OUT"
python hybrid_to_pressure.py "$YEAR" "$MONTH" "$VARNAME" "$VARNAME_OUT"

