#!/bin/bash
## Installs status-check
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=status-check

echo Create $NS namespace
kubectl create ns $NS


function installing_status_check() {
  echo Updating repos
  helm repo add mosip https://mosip.github.io/mosip-helm
  helm repo update

  echo Installing status-check
  helm -n $NS install staus-check mosip/status-check
return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_status_check   # calling function
