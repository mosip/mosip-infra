#!/bin/bash
# Installs the admin module
# Make sure you have updated ui_values.yaml
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=admin
CHART_VERSION=12.0.1-B2

echo Create $NS namespace
kubectl create ns $NS

function installing_admin() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  API_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
  ADMIN_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-admin-host})

  echo Installing Admin-Proxy into Masterdata and Keymanager.
  kubectl -n $NS apply -f admin-proxy.yaml

  echo Installing admin hotlist service.
  helm -n $NS install admin-hotlist mosip/admin-hotlist --version $CHART_VERSION

  echo Installing admin service. Will wait till service gets installed.
  helm -n $NS install admin-service mosip/admin-service --set istio.corsPolicy.allowOrigins\[0\].prefix=https://$ADMIN_HOST --wait --version $CHART_VERSION

  echo Installing admin-ui
  helm -n $NS install admin-ui mosip/admin-ui --set admin.apiUrl=https://$API_HOST/v1/ --set istio.hosts\[0\]=$ADMIN_HOST --version $CHART_VERSION

  kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

  echo Installed admin services

  echo "Admin portal URL: https://$ADMIN_HOST/admin-ui/"
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_admin   # calling function