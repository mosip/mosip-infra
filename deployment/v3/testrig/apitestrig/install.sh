#!/bin/bash
# Installs apitestrig
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=apitestrig
CHART_VERSION=12.0.1-B3

echo Create $NS namespace
kubectl create ns $NS

function installing_apitestrig() {
  echo Istio label
  kubectl label ns $NS istio-injection=disabled --overwrite
  helm repo update

  echo Copy configmaps
  ./copy_cm.sh

  echo Copy secrets
  ./copy_secrets.sh

  echo "Delete s3, db, & apitestrig configmap if exists"
  kubectl -n $NS delete --ignore-not-found=true configmap s3
  kubectl -n $NS delete --ignore-not-found=true configmap db
  kubectl -n $NS delete --ignore-not-found=true configmap apitestrig

  DB_HOST=$( kubectl -n default get cm global -o json  |jq -r '.data."mosip-api-internal-host"' )
  API_INTERNAL_HOST=$( kubectl -n default get cm global -o json  |jq -r '.data."mosip-api-internal-host"' )
  ENV_USER=$( kubectl -n default get cm global -o json |jq -r '.data."mosip-api-internal-host"' | awk -F '.' '/api-internal/{print $1"."$2}')

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
    ENABLE_INSECURE='--set apitestrig.configmaps.apitestrig.ENABLE_INSECURE=true';
  fi

  echo Installing apitestrig
  helm -n $NS install apitestrig mosip/apitestrig \
  --set crontime="0 $time * * *" \
  -f values.yaml \
  --version $CHART_VERSION \
  --set apitestrig.configmaps.s3.s3-host='http://minio.minio:9000' \
  --set apitestrig.configmaps.s3.s3-user-key='admin' \
  --set apitestrig.configmaps.s3.s3-region='' \
  --set apitestrig.configmaps.db.db-server="$DB_HOST" \
  --set apitestrig.configmaps.db.db-su-user="postgres" \
  --set apitestrig.configmaps.db.db-port="5432" \
  --set apitestrig.configmaps.apitestrig.ENV_USER="$ENV_USER" \
  --set apitestrig.configmaps.apitestrig.ENV_ENDPOINT="https://$API_INTERNAL_HOST" \
  --set apitestrig.configmaps.apitestrig.ENV_TESTLEVEL="smokeAndRegression" \
  $ENABLE_INSECURE

  echo Installed apitestrig.
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_apitestrig   # calling function
