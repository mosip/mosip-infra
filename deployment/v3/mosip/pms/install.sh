#!/bin/bash
# Installs all PMS charts
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=pms
CHART_VERSION=0.0.1-develop
API_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
PMP_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-pmp-host})
PMP_NEW_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-pmp-reactjs-ui-host})

echo Create $NS namespace
kubectl create ns $NS

function installing_pms() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  INTERNAL_API_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
  PMP_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-pmp-host})
  PMP_NEW_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-pmp-reactjs-ui-host})

  echo Installing partner manager
  helm -n $NS install pms-partner mosip/pms-partner --set istio.corsPolicy.allowOrigins\[0\].prefix=https://$PMP_HOST --set istio.corsPolicy.allowOrigins\[1\].prefix=https://$PMP_NEW_HOST --version $CHART_VERSION

  echo Installing policy manager
  helm -n $NS install pms-policy mosip/pms-policy --set istio.corsPolicy.allowOrigins\[0\].prefix=https://$PMP_HOST --set istio.corsPolicy.allowOrigins\[1\].prefix=https://$PMP_NEW_HOST --version $CHART_VERSION

  echo Installing pmp-ui
  helm -n $NS install pmp-ui mosip/pmp-ui  --set pmp.apiUrl=https://$INTERNAL_API_HOST/ --set istio.hosts=["$PMP_HOST"] --version $CHART_VERSION

  echo Installing pmp-reactjs-ui
  helm -n $NS template pmp-reactjs-ui mosip/pmp-reactjs-ui --set pmp_new.react_app_partner_manager_api_base_url=$INTERNAL_API_HOST \
  --set pmp_new.react_app_policy_manager_api_base_url=$INTERNAL_API_HOST \
  --set istio.hosts=["$PMP_NEW_HOST"] --version $CHART_VERSION

  kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

  echo Installed pms services

  echo "Admin portal URL: https://$PMP_HOST/pmp-ui/"
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_pms   # calling function
