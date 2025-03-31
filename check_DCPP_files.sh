#!/bin/bash

# check the final CMORized files for all members, for each var/frequency
# jedwards is running the E3SM-style CMORization code
# location of this script: /glade/work/sglanvil/CCR/yeager/check_DCPP_files.sh 

dir=/glade/campaign/cesm/development/espwg/CESM2-DP/DCPP_submission/CMIP6/DCPP/NCAR/CESM2/dcppA-hindcast/

for iyear in {1960..2023}; do
        echo _________________________________________
        echo ________________YEAR_${iyear}________________
        for varDir in ${dir}/s${iyear}-r1i1p1f1/*/*; do
                ifreq=$(echo "${varDir}" | sed -n 's|.*r1i1p1f1/\([^/]*\)/.*|\1|p')
                ivar=$(echo "${varDir}" | sed -e 's|.*/||')
                fileCount=$(ls ${varDir}/gn/*nc | wc -l)
                if [[ ${fileCount} -lt 20 ]]; then
                        echo ${ifreq} ${ivar} - ${fileCount}
                fi
        done
        echo
        echo
done
