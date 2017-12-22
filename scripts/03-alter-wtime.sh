#!/usr/bin/env bash

# ###
#
#  A script to alter jobs walltime. To be used AFTER run of script
#  02-submit-scripts.sh
#
#  Use:
#
#   ./03-alter-wtime.sh
#
#  @author Patrick G. Durand, Ifremer, Nov 2017
# 


# File containing PBS job IDs (see 02-submit-scripts.sh)
FILE="job-list.txt"

# new walltime value; unit is hours (192h=one week)
WALLTIME=192

# qlater can only be executed by user 'root'
ME=`whoami`
if [[ "$ME" != "root"  ]] ; then
  echo "run this script as root!"
  exit 1
fi

nbscriptok=0

# qalter jobs
while IFS= read -r line
do
  SCRIPT=${line%:*}
  JOBID=${line#*:}
  CMD="qalter -l walltime=${WALLTIME}:00:00 $JOBID"
  echo $CMD
  eval $CMD
  nbscriptok=$((nbscriptok+1))
done < "$FILE"

echo ""
echo "$nbscriptok jobs updated. Walltime set to: $WALLTIME hours"

