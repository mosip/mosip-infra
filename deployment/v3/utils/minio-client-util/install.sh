#!/bin/bash
# Installs minio-client-util
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=minio-client-util
CHART_VERSION=1.0.0-P1

echo Create $NS namespace
kubectl create ns $NS

function installing_minio-client-util() {
  helm repo update

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

  read -p "Please provide S3 Server URL (Default value:'http://minio.minio:9000')" S3_SERVER_URL
  if [ -z "$S3_SERVER_URL" ]; then
      echo "ERROR: S3 Server URL not Specified; EXITING;";
      exit 1;
  fi

  read -p "Please provide S3 Access Key " S3_ACCESS_KEY
  if [ -z "$S3_ACCESS_KEY" ]; then
      echo "ERROR: Access Key not Specified; EXITING;";
      exit 1;
  fi

  echo "Please provide S3 Secret Key"
  read -s S3_SECRET_KEY
  if [ -z "$S3_SECRET_KEY" ]; then
      echo "ERROR: Secret Key not Specified; EXITING;";
      exit 1;
  fi

  read -p "Please provide number of days the objects needed to be cleared from minio [format:'no_of_days'd](eg:3d) : " S3_RETENTION_DAYS
  if [ -z "$S3_RETENTION_DAYS" ]; then
      echo "ERROR: Number of days to clear the test report cannot be empty; EXITING;";
      exit 1;
  fi

  read -p "Please provide bucket name for which objects needs to be removed: " BUCKET_NAME
  if [ -z "$BUCKET_NAME" ]; then
      echo "ERROR: Bucket name cannot be empty; EXITING;";
      exit 1;
  fi

  echo Installing minio-client-util
  helm -n $NS install minio-client-util mosip/minio-client-util --set minioclient.retention_days=$S3_RETENTION_DAYS \
  --set crontime="0 $time * * *" \
  --set minioclient.configmaps.s3.s3_bucket_name=$BUCKET_NAME \
  --set minioclient.configmaps.s3.s3_host=$S3_SERVER_URL \
  --set minioclient.configmaps.s3.s3_access_key=$S3_ACCESS_KEY \
  --set minioclient.configmaps.s3.s3_secret_key=$S3_SECRET_KEY \
  --version $CHART_VERSION

  
  echo Installed minio client utility
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_minio-client-util  # calling function
