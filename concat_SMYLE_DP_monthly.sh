#!/bin/bash
#PBS -N SMYLE_concat 
#PBS -A CESM0020 
#PBS -l select=1:ncpus=1:mem=10GB
#PBS -l walltime=01:00:00
#PBS -k eod
#PBS -j oe
#PBS -q casper
#PBS -m a 

# location of this script: /glade/work/sglanvil/CCR/yeager/concat_SMYLE_DP_monthly.sh

module load nco
for imember in {011..030}; do
        case=b.e21.BSMYLE.f09_g17.${iyear}-${imonth}.${imember}
        if [ "$iyear" -ge 2020 ] && [ "$iyear" -lt 2023 ]; then
                echo "iyear is in the range 2020 to 2022."
                imember=$((10#$imember - 10))
                imember=$(printf "%03d" "$imember")
                case=b.e21.BSMYLE-XT.f09_g17.${iyear}-${imonth}.${imember}
                imember=$((10#$imember + 10))
                imember=$(printf "%03d" "$imember")
        fi
        if [ "$iyear" -eq 2023 ]; then
                echo "iyear is 2023."
                imember=$((10#$imember - 10))
                imember=$(printf "%03d" "$imember")
                case=b.e21.BSMYLE-XT-beta.f09_g17.${iyear}-${imonth}.${imember}
                imember=$((10#$imember + 10))
                imember=$(printf "%03d" "$imember")
        fi
        echo ${case}
        dirSMYLE=/glade/campaign/cesm/development/espwg/SMYLE/archive/${case}/atm/proc/tseries/day_1/
        dirDP=/glade/campaign/cesm/development/espwg/CESM2-DP/timeseries/${case}/atm/proc/tseries/day_1/
        if [ ! -d ${dirSMYLE} ] || [ ! -d ${dirDP} ]; then
                echo ${iyear} ${imember} "directory does not exist <skipping> - SASHA"
                continue
        fi
        echo ${iyear} ${imember}
        file1=$(ls ${dirSMYLE}*.h1.${ivar}.${iyear}*)
        file2=$(ls ${dirDP}*.h1.${ivar}.$((iyear+2))*)

        file1BEGIN=${file1: -16:6}
        file1END=${file1: -9:6}
        file2BEGIN=${file2: -16:6}
        file2END=${file2: -9:6}

        basename1=$(basename ${file1})
        destDirNew=${destDir}/b.e21.BSMYLE.f09_g17.${iyear}-${imonth}.${imember}/atm/proc/tseries/day_1/
        mkdir -p ${destDirNew}
        outFile=${destDirNew}/${basename1:0:-9}${file2END}.nc
        if [[ ${file1END} = ${file2BEGIN} ]]; then
                # ------ OVERLAP ------
                ncks -O -d time,1,98 ${file2} ${destDirNew}/temp_${iyear}_${imonth}.nc
                ncrcat -O ${file1} ${destDirNew}/temp_${iyear}_${imonth}.nc ${outFile}
                rm ${destDirNew}/temp_${iyear}_${imonth}.nc
        else
                # ------ NO OVERLAP ------
                ncks -O -d time,0,97 ${file2} ${destDirNew}/temp_${iyear}_${imonth}.nc
                ncrcat -O ${file1} ${destDirNew}/temp_${iyear}_${imonth}.nc ${outFile}
                rm ${destDirNew}/temp_${iyear}_${imonth}.nc
        fi

        timeLength=$(ncdump -h ${outFile} | grep UNLIMITED | grep -o '[0-9]*')
        if [ ${timeLength} != 122 ]; then
                echo ${iyear} ${imember} "is not the corret time length - SASHA"
        fi

        if [ "$iyear" -ge 2020 ] && [ "$iyear" -lt 2023 ]; then
                old_member=$(echo "$outFile" | sed -E 's/.*\.([0-9]{3})\..*/\1/')
                new_member=$(printf "%03d" $((10#$old_member + 10)))
                newFile=$(echo "$outFile" | sed -E "s/\.${old_member}\./.${new_member}./")
                mv ${outFile} ${newFile}
                rename "BSMYLE-XT" "BSMYLE" ${newFile}
        fi
        if [ "$iyear" -eq 2023 ]; then
                old_member=$(echo "$outFile" | sed -E 's/.*\.([0-9]{3})\..*/\1/')
                new_member=$(printf "%03d" $((10#$old_member + 10)))
                newFile=$(echo "$outFile" | sed -E "s/\.${old_member}\./.${new_member}./")
                mv ${outFile} ${newFile}
                rename "BSMYLE-XT-beta" "BSMYLE" ${newFile}
        fi
done

exit
