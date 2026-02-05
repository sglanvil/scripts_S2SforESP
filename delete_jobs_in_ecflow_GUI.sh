#!/bin/bash
# location on derecho: /glade/u/home/ssfcst/delete_jobs_in_ecflow_GUI.sh 

caseName=cesm2cam6_basicRealtime
export ECF_PORT=35254
export ECF_HOST=derecho7

ecflow_client --get_state | grep "NODE /${caseName}_.*/getdata" \
        | grep -oE '[0-9]{4}_[0-9]{2}_[0-9]{2}' \
        | while read -r dateStr; do
                echo "/${caseName}_${dateStr}"
                printf "y\n" | ecflow_client --delete="/${caseName}_${dateStr}"
        done

