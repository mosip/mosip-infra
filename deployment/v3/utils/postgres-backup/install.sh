#!/bin/bash
# Installs postgres-backup
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=postgres-backup
CHART_VERSION=0.0.1-develop

echo Create $NS namespace
kubectl create ns $NS

function installing_postgres-backup() {
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

  read -p "Please provide DB HOST: " DB_HOST
  if [ -z "DB_HOST" ]; then
              echo "ERROR: DB HOST not Specified; EXITING;";
              exit 1;
  fi

  read -p "Please provide DB USER: " DB_USER
  if [ -z "DB_USER" ]; then
        echo "ERROR: DB USER not Specified; EXITING;";
        exit 1;
  fi

  read -p "Please provide DB PORT: " DB_PORT
  if [ -z "DB_PORT" ]; then
          echo "ERROR: DB PORT not Specified; EXITING;";
          exit 1;
  fi

  echo "Please provide DB PASSWORD"
  read -s DB_PASSWORD
  if [ -z "DB_PASSWORD" ]; then
          echo "ERROR: DB PASSWORD not Specified; EXITING;";
          exit 1;
  fi

  read -p "Please provide the number of latest backups to keep in the S3 bucket (e.g., 5) : " NUM_BACKUPS_TO_KEEP
  if [ -z "$NUM_BACKUPS_TO_KEEP" ]; then
        echo "ERROR: Number of backups to keep in the S3 bucket not specified.; EXITING;";
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


  echo Installing postgres-backup
  helm -n $NS install postgres-backup mosip/postgresbackup \
  --set crontime="0 $time * * *" \
  --set "postgresbackup.configmaps.s3.S3_BUCKET=$S3_BUCKET" \
  --set "postgresbackup.configmaps.s3.AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
  --set "postgresbackup.configmaps.s3.AWS_DEFAULT_REGION=$AWS_REGION" \
  --set "postgresbackup.configmaps.s3.NUM_BACKUPS_TO_KEEP=$NUM_BACKUPS_TO_KEEP" \
  --set "postgresbackup.configmaps.db.DB_USER=$DB_USER" \
  --set "postgresbackup.configmaps.db.DB_HOST=$DB_HOST" \
  --set "postgresbackup.configmaps.db.DB_PORT=$DB_PORT" \
  --set "postgresbackup.secrets.db.DB_PASSWORD=$DB_PASSWORD" \
  --set "postgresbackup.secrets.s3.AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
  --version $CHART_VERSION

  echo Installed postgres backup utility
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_postgres-backup  # calling function
