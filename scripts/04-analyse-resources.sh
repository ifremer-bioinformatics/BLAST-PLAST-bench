#!/usr/bin/env bash

set -E
trap '[ "$?" -ne 77 ] || exit 77' ERR

# ###
#
#  A script to get job information. To be used AFTER run of script
#  02-submit-scripts.sh
#
#  Use:
#
#   ./04-analyse-resources.sh
#
#  @author Patrick G. Durand, Ifremer, Nov 2017
# 

# File containing PBS job IDs (see 02-submit-scripts.sh)
FILE="job-list.txt"
# tmp working file
STATFILE="stats.tmp"

# --------
# FUNCTION: print out an simple message on stderr (only if SILENT mode is off)
function errorMsg(){
  printf "$* \n" >&2
}

# --------
# FUNCTION: print out an error message on stderr and exit from application
function throw () {
  errorMsg "$* \n"
  exit 77
}


function getProperty(){

  value=$(cat $STATFILE | grep "$1")
  if [[ -z "$value" ]] ; then
    throw "ERROR: unknown property: $1"
  fi
  value=$(echo $value | cut -d'=' -f 2 | awk '{$1=$1};1')
  echo $value
}

function getSeconds(){
  value=`echo $1 | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }'`
  echo $value
}

# Separator char used to produced 'CSV' data table
SEP="\t"

# Print out header of the table
printf "QUERY${SEP}SUBJECT${SEP}CPUS(c)${SEP}MEM(Gb)${SEP}CPUPCT${SEP}CPUTIME"
printf "${SEP}MEM(Mb)${SEP}NCPUS${SEP}VMEM(Mb)${SEP}WALLTIME(s)"
printf "${SEP}QTIME(s)${SEP}STIME(s)${SEP}DELTA(s)${SEP}JOBID\n"

# Loop on jobs list
while IFS= read -r line
do
  # get script name
  SCRIPT=${line%:*}
  # exclude script name extension
  SCRIPT=`echo $SCRIPT | cut -d'.' -f 1`
  # first string of script: query type
  QUERY=`echo $SCRIPT | cut -d'-' -f 1`
  # second string of script: subject type
  SUBJECT=`echo $SCRIPT | cut -d'-' -f 2`
  # third string of script: memory requested
  RMEM=`echo $SCRIPT | cut -d'-' -f 3`
  # (remove unit: gb)
  RMEM=${RMEM%g*}
  # fourth string in script: nb cores requested
  CORES=`echo $SCRIPT | cut -d'-' -f 4`
  # (remoce unit: c)
  CORES=${CORES%c*}
  # get job ID
  JOBID=${line#*:}
  # get resources used for a particular job
  qstat -fx $JOBID | grep 'resources_used\|qtime\|stime' > $STATFILE
  # get values
  CPUPERCENT=$(getProperty 'cpupercent')
  CPUT=$(getProperty "cput")
  CPUT=$(getSeconds $CPUT)
  MEM=$(getProperty "used.mem")
  MEM=${MEM%k*}
  iMEM=$((MEM / 1024))
  NCPUS=$(getProperty "ncpus")
  VMEM=$(getProperty "vmem")
  VMEM=${VMEM%k*}
  iVMEM=$((VMEM / 1024))
  WALLTIME=$(getProperty "walltime")
  WALLTIME=$(getSeconds $WALLTIME)
  QTIME=$(getProperty "qtime")
  STIME=$(getProperty "stime")
  # convert values to epoch (unit is seconds)
  QTIME_S=`date --date="$QTIME" +%s`
  STIME_S=`date --date="$STIME" +%s`
  DELTA_S=$((STIME_S-QTIME_S))
  # dump data line
  printf "%s${SEP}%s${SEP}%s${SEP}%s${SEP}%s${SEP}%s${SEP}%s${SEP}%s${SEP}%s${SEP}%s${SEP}%s${SEP}%s${SEP}%s${SEP}%s\n" \
         $QUERY $SUBJECT $CORES $RMEM $CPUPERCENT \
         $CPUT $iMEM $NCPUS $iVMEM $WALLTIME \
         $QTIME_S $STIME_S $DELTA_S $JOBID
  rm -f $STATFILE
done < "$FILE"


