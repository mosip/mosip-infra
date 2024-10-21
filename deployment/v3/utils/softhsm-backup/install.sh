#!/bin/bash
# Installs softhsm-backup
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=softhsm-backup
CHART_VERSION=0.0.1-develop

echo Create $NS namespace
kubectl create ns $NS

function installing_softhsm-backup() {
  helm repo update

  read -p "Please provide S3 Bucket Name: " S3_BUCKET
  if [ -z "S3_BUCKET" ]; then
     echo "ERROR: S3 Bucket Name not Specified; EXITING;";
     exit 1;
  fi

  read -p "Please provide AWS ACCESS KEY ID: " AWS_ACCESS_KEY_ID
  if [ -z "AWS_ACCESS_KEY_ID" ]; then
      echo "ERROR: AWS ACCESS KEY ID not Specified; EXITING;";
      exit 1;
  fi


  echo "Please provide AWS SECRET ACCESS KEY"
  read -s AWS_SECRET_ACCESS_KEY
  if [ -z "AWS_SECRET_ACCESS_KEY" ]; then
      echo "ERROR: AWS SECRET ACCESS KEY not Specified; EXITING;";
      exit 1;
  fi


  read -p "Please provide AWS REGION: " AWS_REGION
  if [ -z "AWS_REGION" ]; then
      echo "ERROR: AWS REGION not Specified; EXITING;";
      exit 1;
  fi

  read -p "Please provide number of days the objects needed to be cleared from s3 bucket (eg:15) : " S3_RETENTION_DAYS
    if [ -z "$S3_RETENTION_DAYS" ]; then
        echo "ERROR: Number of days to clear the objects empty; EXITING;";
        exit 1;
    fi

  read -p "Please enter the time(hr) to run the cronjob every day (time: 0-23) : " time
  if [ -z "$time" ]; then
     echo "ERROR: Time cannot be empty; EXITING;";
     exit 1;
  fi
  if ! [ $time -eq $time ] 2>/dev/null; then
     echo "ERROR: Time $time is not a number; EXITING;";
     exit 1;
  fi
  if [ $time -gt 23 ] || [ $time -lt 0 ] ; then
     echo "ERROR: Time should be in range ( 0-23 ); EXITING;";
     exit 1;
  fi


  echo Installing softhsm-backup
  helm -n $NS install softhsm-backup mosip/softhsmbackup \
  --set crontime="0 $time * * *" \
  --set "softhsmbackup.configmaps.s3.S3_BUCKET=$S3_BUCKET" \
  --set "softhsmbackup.configmaps.s3.AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
  --set "softhsmbackup.configmaps.s3.AWS_REGION=$AWS_REGION" \
  --set "softhsmbackup.configmaps.s3.S3_RETENTION_DAYS=$S3_RETENTION_DAYS" \
  --set "softhsmbackup.secrets.s3.AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
  --version $CHART_VERSION

  echo Installed softhsm backup utility
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_softhsm-backup  # calling function
