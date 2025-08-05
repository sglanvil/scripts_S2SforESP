# run on casper
set -e

imonth=11
ivar=V

for iyear in {2021..2021}; do
        for imbr in {001..020}; do
                export iyear
                export imbr
		export imonth
		export ivar
		qsub -v iyear,imbr,imonth,ivar /glade/derecho/scratch/sglanvil/holdingCell/E3SM_mapped/map_files.sh 
	done
done

