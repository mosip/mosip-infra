#!/bin/bash
# Installs pmptest automation
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=pmptest
CHART_VERSION=12.0.1-B3

echo Create $NS namespace
kubectl create ns $NS


function installing_pmptest() {
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
  echo "n: if you don't have public domain & valid ssl certificate"
  read -p "" flag
  
  if [ -z "$flag" ]; then
    echo "'flag' was provided; EXITING;"
    exit 1;
  fi
  ENABLE_INSECURE=''
  if [ "$flag" = "n" ]; then
    ENABLE_INSECURE='--set pmptest.configmaps.pmptest.ENABLE_INSECURE=true';
  fi

  echo Istio label
  kubectl label ns $NS istio-injection=disabled --overwrite
  helm repo update

  echo Copy configmaps
  ./copy_cm.sh

  echo Copy secrets
  ./copy_secrets.sh

  DB_HOST=$( kubectl -n default get cm global -o json  |jq -r '.data."mosip-api-internal-host"' )
  API_INTERNAL_HOST=$( kubectl -n default get cm global -o json  |jq -r '.data."mosip-api-internal-host"' )
  USER=$( kubectl -n default get cm global -o json |jq -r '.data."mosip-api-internal-host"')


  echo Installing pmptest
  helm -n $NS install pmptest /home/techno-376/IdeaProjects/mosip-helm/charts/uitestrig/ \
  --set crontime="0 $time * * *" \
  -f values.yaml  \
  --version $CHART_VERSION \
  --set pmptest.configmaps.s3.s3-host='http://minio.minio:9000' \
  --set pmptest.configmaps.s3.s3-user-key='uiautomation' \
  --set pmptest.configmaps.s3.s3-region='' \
  --set pmptest.configmaps.db.db-server="$DB_HOST" \
  --set pmptest.configmaps.db.db-su-user="postgres" \
  --set pmptest.configmaps.db.db-port="5432" \
  --set pmptest.configmaps.pmptest.USER="$USER" \
  --set pmptest.configmaps.pmptest.ENDPOINT="https://$API_INTERNAL_HOST" \

  $ENABLE_INSECURE
  
  echo Installed pmptest and ui reports will be moved to S3 under uiautomation bucket.
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_pmptest   # calling function
