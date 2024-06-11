#!/bin/bash
# Installs s3-readuser-util
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=s3-readuser-util
CHART_VERSION=0.0.1-develop

echo Create $NS namespace
kubectl create ns $NS

function installing_s3-readuser-util() {

  echo Installing s3-readuser-util
  helm -n $NS install s3-readuser-util mosip/s3-readuser-utill --version $CHART_VERSION

  echo Installed s3-readuser-util
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_s3-readuser-util  # calling function