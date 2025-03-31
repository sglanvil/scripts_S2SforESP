#!/bin/bash

# March 26, 2025
# Purpose: move away any daily cam files that have the wrong time length

# location: /glade/work/sglanvil/CCR/yeager/move_bad_daily_files.sh 

baseDir=/glade/campaign/cesm/development/espwg/CESM2-DP/timeseries/

# Note: only do through 2019, then change imbr range to {001..020} and caseName for 2020-2023
for iyear in {1990..1999}; do
        echo
        for imbr in {011..030}; do
                for ifile in ${baseDir}/b.e21.BSMYLE.f09_g17.${iyear}-11.${imbr}/atm/proc/tseries/day_1/*.PRECTMX.*nc; do
                        timeLength=$(ncdump -h ${ifile} | grep UNLIM | sed 's/[^0-9]//g')
                        if [[ ${timeLength} -lt 2982 ]]; then
                                echo ${iyear} ${imbr} ${timeLength}
                                baddieDir=${baseDir}/b.e21.BSMYLE.f09_g17.${iyear}-11.${imbr}/atm/proc/tseries/day_1/badLength/
                                mkdir -p ${baddieDir}
                                mv ${ifile} ${baddieDir}/
                        fi
                done
        done
done

