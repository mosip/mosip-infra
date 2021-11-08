#!/usr/bin/env bash

## Check arguments for the script
echo "syntax: bash healthCheckViaBashScript.sh healthCheckUrlList workingDir"
if [ $# -ne 2 ]; then
  echo "healthCheckUrlList file  or workDir not provided; EXITING" | tee -a $logFile
  exit 1;
elif [ ! -f $1 ]; then
  echo "$1 healthCheckUrlList file or workDir not found; EXITING" | tee -a $logFile
  exit 1;
fi

healthCheckUrlList=$(< $1)                      ## save content of file into a variable

################ SET LOGS #####################
datetime=$( date +'%d-%m-%Y-%H-%M-%S' )       ## get current datetime
workDir=$2                                    ## set working dir
logDir="$workDir/logs"                        ## set log Dirs
logFile="$logDir/HealthCheckLog_$datetime"    ## set logFIle
mkdir -p $logDir                              ## create working dir & log Dir
find $logDir -type f -mmin +180 -delete       ## delete old log files
touch $logFile                                ## create empty log file


############## Install JQ package ###############################
if [[ ! -f "$workDir/jq-linux64" ]]; then
  cd $workDir && wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
  chmod +x "$workDir/jq-linux64"
fi


for i in $healthCheckUrlList; do
  curlOutput=$(curl -s $i | $workDir/jq-linux64 '.status' )
  echo -e "url=$i  \t status: $curlOutput" | tee -a $logFile
  if [[ -z $curlOutput || $curlOutput != \"UP\" ]]; then
      echo "NOT ABLE TO ACCESS URL $i; EXITING" | tee -a $logFile
      exit 1;
  fi
done
exit 0;


## References
#1. https://github.com/kubernetes/kubernetes/issues/37218
