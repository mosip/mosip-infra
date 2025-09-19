#!/bin/bash
# Installs MinIO using helm chart inside MOSIP cluster
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=minio

echo Create $NS namespace
kubectl create ns $NS
kubectl label ns $NS istio-injection=enabled --overwrite

function installing_minio() {
  echo Installing minio
  helm -n minio upgrade --install minio mosip/minio \
    --version 10.1.6 \
    --set image.repository=bitnamilegacy/minio \
    --set image.tag=2025.2.28-debian-12-r1 \
    --set clientImage.repository=bitnamilegacy/minio-client \
    --set clientImage.tag=2025.2.21-debian-12-r1 \
    --set volumePermissions.image.repository=bitnamilegacy/os-shell \
    --set volumePermissions.image.tag=12-debian-12-r39 \
    --set global.security.allowInsecureImages=true

  echo Installing gateways and virtualservice
  EXTERNAL_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-minio-host})

  echo host: $EXTERNAL_HOST
  helm -n $NS install istio-addons chart/istio-addons --set externalHost=$EXTERNAL_HOST

  echo Helm installed. Next step is to execute the cred.sh to update secrets in s3 namespace
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_minio   # calling function
