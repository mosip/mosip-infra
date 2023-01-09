#!/bin/bash
# Installs all kernel helm charts
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=kernel
CHART_VERSION=12.0.1-B2

echo Create $NS namespace
kubectl create ns $NS

function installing_kernel() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  echo Installing authmanager
  helm -n $NS install authmanager mosip/authmanager --version $CHART_VERSION 

  echo Installing auditmanager
  helm -n $NS install auditmanager mosip/auditmanager --version $CHART_VERSION

  echo Installing idgenerator
  helm -n $NS install idgenerator mosip/idgenerator --version $CHART_VERSION

  ADMIN_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-admin-host})
  echo Installing masterdata and allowing Admin UI to access masterdata services.
  helm -n $NS install masterdata mosip/masterdata  --set istio.corsPolicy.allowOrigins\[0\].exact=https://$ADMIN_HOST  --version $CHART_VERSION

  echo Installing otpmanager
  helm -n $NS install otpmanager mosip/otpmanager --version $CHART_VERSION

  echo Installing pridgenerator
  helm -n $NS install pridgenerator mosip/pridgenerator --version $CHART_VERSION

  echo Installing ridgenerator
  helm -n $NS install ridgenerator mosip/ridgenerator --version $CHART_VERSION

  echo Installing syncdata
  helm -n $NS install syncdata mosip/syncdata --version $CHART_VERSION

  echo Installing notifier
  helm -n $NS install notifier mosip/notifier --version $CHART_VERSION

  kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

  echo Installed kernel services
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_kernel   # calling function
