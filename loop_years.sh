# run on casper

# location of this script: /glade/work/sglanvil/CCR/yeager

# There are two scripts total: loop_years.sh and concat_SMYLE_DP.sh

# Specify: ivar, imonth, destDir, and start/end years in this script
# Specify: account key (eg, CESM0021) in concat_SMYLE_DP.sh script
# Logon to casper, then submit like this: bash loop_years.sh

ivar=AR
imonth=11
destDir=/glade/campaign/cesm/development/espwg/CESM2-DP/DCPP_submission/

export destDir
export ivar
export imonth
for iyear in {1958..2023}; do
        export iyear
        qsub -v iyear,ivar,imonth,destDir concat_SMYLE_DP.sh
done
