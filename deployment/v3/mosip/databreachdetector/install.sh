#!/bin/bash
# Installs sample print service
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=databreachdetector
CHART_VERSION=0.0.1-develop

echo Create $NS namespace
kubectl create ns $NS 

function installing_databreachdetector() {
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

  DB_HOST=$( kubectl -n default get cm global -o json  |jq -r '.data."mosip-postgres-host"' )
  S3_USER_KEY=$( kubectl -n s3 get cm s3 -o json  |jq -r '.data."s3-user-key"' )
  S3_REGION=$( kubectl -n s3 get cm s3 -o json  |jq -r '.data."s3-region"' )

  echo Installing databreachdetector
  helm -n $NS install databreachdetector mosip/databreachdetector --wait --version $CHART_VERSION \
  --set databreachdetector.configmaps.db.db-server="$DB_HOST" \
  --set databreachdetector.configmaps.s3.s3-bucket-name='secure-datarig' \
  --set databreachdetector.configmaps.s3.s3-region="$S3_REGION" \
  --set databreachdetector.configmaps.s3.s3-host='minio.minio:9000' \
  --set databreachdetector.configmaps.s3.s3-user-key="$S3_USER_KEY"
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_databreachdetector   # calling function
