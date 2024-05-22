#!/bin/bash
# Installs sample print service
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=mosipcertmanager
CHART_VERSION=0.0.1-develop

echo Create $NS namespace
kubectl create ns $NS 

function installing_mosipcertmanager() {
  echo Istio label
  kubectl label ns $NS istio-injection=disabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  kubectl -n $NS delete --ignore-not-found=true cm s3
  ./copy_cm.sh

  echo Copy secrets
  sed -i 's/\r$//' copy_secrets.sh
  ./copy_secrets.sh

  DEFAULT_DB_HOST='postgres-postgresql.postgres'
  S3_USER_KEY=$( kubectl -n s3 get cm s3 -o json  |jq -r '.data."s3-user-key"' )
  S3_REGION=$( kubectl -n s3 get cm s3 -o json  |jq -r '.data."s3-region"' )

  read  -p "Please provide DB host name ( Default: postgres-postgresql.postgres ) : " DB_HOST
  DB_HOST=${DB_HOST:-$DEFAULT_DB_HOST}

  if [ -z $DB_HOST ]; then
    echo "Host name not provided; EXITING;"
    exit 1;
  fi



  echo Installing mosipcertmanager
  helm -n $NS install mosipcertmanager mosip/mosipcertmanager --wait --version $CHART_VERSION \
  --set mosipcertmanager.configmaps.db.db-server="$DB_HOST" \
  --set mosipcertmanager.configmaps.s3.s3-region="$S3_REGION" \
  --set mosipcertmanager.configmaps.s3.s3-host='minio.minio:9000' \
  --set mosipcertmanager.configmaps.s3.s3-user-key="$S3_USER_KEY"
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_mosipcertmanager   # calling function
