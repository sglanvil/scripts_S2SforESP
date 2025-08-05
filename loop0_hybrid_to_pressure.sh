# run on casper
set -e

MONTH="11"
VARNAME="V"
VARNAME_OUT="V250"

for YEAR in {1981..2021}; do
	export YEAR 
	export MONTH 
	export VARNAME
	export VARNAME_OUT
	qsub -v YEAR,MONTH,VARNAME,VARNAME_OUT loop_hybrid_to_pressure.sh 
done

