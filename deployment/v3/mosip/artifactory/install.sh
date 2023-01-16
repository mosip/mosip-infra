#!/bin/bash
# Installs artifactory
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=artifactory
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS

function installing_artifactory() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Installing artifactory
  helm -n $NS install artifactory mosip/artifactory --version $CHART_VERSION

  kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

  echo Installed artifactory service

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  echo Copied artifactory share as artifactory-share-develop

  kubectl patch cm -n $NS artifactory-share-beta1 --type merge -p '{"data":{"iam_adapter_url_env":"http://artifactory.artifactory:80/artifactory/libs-release-local/io/mosip/kernel/1.2.0.1-B1/kernel-auth-adapter.jar"}}'

  kubectl patch cm -n $NS artifactory-share-beta1 --type merge -p '{"data":{"virusscanner_url_env":"http://artifactory.artifactory:80/artifactory/libs-release-local/clamav/1.2.0.1-B1/kernel-virusscanner-clamav.jar"}}'
  
  echo Updating the artifactory-share-develop configmap to point to develop jar for iam_adapter_url_env
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_artifactory   # calling function
