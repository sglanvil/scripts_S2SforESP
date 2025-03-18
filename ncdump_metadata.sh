#!/bin/bash

# location of this script: /glade/work/sglanvil/CCR/yeager

dir=/glade/campaign/cesm/development/espwg/CESM2-DP/timeseries/b.e21.BSMYLE.f09_g17.2008-11.013/ice/proc/tseries/month_1/

for ifile in $dir/*.nc; do
        var=$(echo "$ifile" | sed -n 's/.*cice\.h\.\([^\.]*\).*/\1/p')
        ncdump -h $ifile | grep $var:long_name >> DCPP_ice_longName.txt
done

