#!/bin/bash
# Installs dslrig
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=dslrig
CHART_VERSION=12.1.0

echo Create $NS namespace
kubectl create ns $NS

function installing_dslrig() {
  ENV_NAME=$( kubectl -n default get cm global -o json |jq -r '.data."installation-domain"')

  read -p "Please enter the time(hr) to run the cronjob every day (time: 0-23) : " time
  if [ -z "$time" ]; then
     echo "ERROT: Time cannot be empty; EXITING;";
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

  echo "Do you have public domain & valid SSL? (Y/n) "
  echo "Y: if you have public domain & valid ssl certificate"
  echo "n: If you don't have a public domain and a valid SSL certificate. Note: It is recommended to use this option only in development environments."
  read -p "" flag

  if [ -z "$flag" ]; then
    echo "'flag' was provided; EXITING;"
    exit 1;
  fi
  ENABLE_INSECURE=''
  if [ "$flag" = "n" ]; then
    ENABLE_INSECURE='--set enable_insecure=true';
  fi

  read -p "Please provide packet Utility Base URL (eg: https://<host>:<port>/v1/packetcreator) : " packetUtilityBaseUrl

  if [ -z $packetUtilityBaseUrl ]; then
    echo "Packet utility Base URL not provided; EXITING;"
    exit 1;
  fi

  read -p "Please provide the retention days to remove old reports ( Default: 3 )" reportExpirationInDays

  if [[ -z $reportExpirationInDays ]]; then
    reportExpirationInDays=3
  fi
  if ! [[ $reportExpirationInDays =~ ^[0-9]+$ ]]; then
    echo "The variable \"reportExpirationInDays\" should contain only number; EXITING";
    exit 1;
  fi

  echo Istio label
  kubectl label ns $NS istio-injection=disabled --overwrite
  helm repo update

  echo Copy configmaps
  ./copy_cm.sh

  echo Copy secrets
  ./copy_secrets.sh

  echo "Delete s3, db, & dslrig configmap if exists"
  kubectl -n $NS delete --ignore-not-found=true configmap s3
  kubectl -n $NS delete --ignore-not-found=true configmap db
  kubectl -n $NS delete --ignore-not-found=true configmap dslrig

  DB_HOST=$( kubectl -n default get cm global -o json  |jq -r '.data."mosip-api-internal-host"' )
  API_INTERNAL_HOST=$( kubectl -n default get cm global -o json  |jq -r '.data."mosip-api-internal-host"' )
  USER=$( kubectl -n default get cm global -o json |jq -r '.data."mosip-api-internal-host"')

  echo Installing dslrig
  helm -n $NS install dslorchestrator mosip/dslorchestrator \
  --set crontime="0 $time * * *" \
  --version $CHART_VERSION \
  --set dslorchestrator.configmaps.s3.s3-host='http://minio.minio:9000' \
  --set dslorchestrator.configmaps.s3.s3-user-key='admin' \
  --set dslorchestrator.configmaps.s3.s3-region='' \
  --set dslorchestrator.configmaps.db.db-server="$DB_HOST" \
  --set dslorchestrator.configmaps.db.db-su-user="postgres" \
  --set dslorchestrator.configmaps.db.db-port="5432" \
  --set dslorchestrator.configmaps.dslorchestrator.USER="$USER" \
  --set dslorchestrator.configmaps.dslorchestrator.ENDPOINT="https://$API_INTERNAL_HOST" \
  --set dslorchestrator.configmaps.dslorchestrator.packetUtilityBaseUrl="$packetUtilityBaseUrl" \
  --set dslorchestrator.configmaps.dslorchestrator.reportExpirationInDays="$reportExpirationInDays" \
  --set dslorchestrator.configmaps.dslorchestrator.NS="$NS" \
  $ENABLE_INSECURE

  echo Installed dslrig.
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_dslrig   # calling function