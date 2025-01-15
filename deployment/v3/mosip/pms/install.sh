#!/bin/bash
# Installs all PMS charts
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=pms
CHART_VERSION=0.0.1-develop

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
  PMP_REVAMP_UI_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-pmp-revamp-ui-host})

  PARTNER_MANAGER_SERVICE_NAME="pms-partner"
  POLICY_MANAGER_SERVICE_NAME="pms-policy"

  echo Installing partner manager
  helm -n $NS install $PARTNER_MANAGER_SERVICE_NAME mosip/pms-partner \
  --set istio.corsPolicy.allowOrigins\[0\].prefix=https://$PMP_HOST \
  --set istio.corsPolicy.allowOrigins\[1\].prefix=https://$PMP_REVAMP_UI_HOST \
  --set image.repository=mosipdev/partner-management-service --set image.tag=develop-pmp-revamp \
  --version $CHART_VERSION

  echo Installing policy manager
  helm -n $NS install $POLICY_MANAGER_SERVICE_NAME mosip/pms-policy \
  --set istio.corsPolicy.allowOrigins\[0\].prefix=https://$PMP_HOST \
  --set istio.corsPolicy.allowOrigins\[1\].prefix=https://$PMP_REVAMP_UI_HOST \
  --set image.repository=mosipdev/policy-management-service --set image.tag=develop-pmp-revamp \
  --version $CHART_VERSION
  
  # Ask if the user wants to install pmp-ui
  read -p "Do you want to install PMP UI? (y/n): " install_pmp_ui
  if [[ "$install_pmp_ui" =~ ^[Yy]$ ]]; then
    echo Installing pmp-ui
    helm -n $NS install pmp-ui mosip/pmp-ui  --set pmp.apiUrl=https://$INTERNAL_API_HOST/ --set istio.hosts=["$PMP_HOST"] --set image.repository=mosipid/pmp-ui --set image.tag=1.2.0.2 --version $CHART_VERSION
  else
    echo Skipping pmp-ui installation
  fi

  # Ask if the user wants to install pmp-revamp-ui
  read -p "Do you want to install PMP-REVAMP-UI? (y/n): " install_pmp_revamp_ui
  if [[ "$install_pmp_revamp_ui" =~ ^[Yy]$ ]]; then
    echo Installing pmp-revamp-ui
    helm -n $NS install pmp-revamp-ui mosip/pmp-revamp-ui --set image.repository=mosipdev/pmp-revamp-ui --set image.tag=develop \
    --set pmp_revamp.react_app_partner_manager_api_base_url="https://$INTERNAL_API_HOST/v1/partnermanager" \
    --set pmp_revamp.react_app_policy_manager_api_base_url="https://$INTERNAL_API_HOST/v1/policymanager" \
    --set pmp_revamp.pms_partner_manager_internal_service_url="http://$PARTNER_MANAGER_SERVICE_NAME.$NS/v1/partnermanager" \
    --set pmp_revamp.pms_policy_manager_internal_service_url="http://$POLICY_MANAGER_SERVICE_NAME.$NS/v1/policymanager" \
    --set istio.hosts=["$PMP_REVAMP_UI_HOST"] --version $CHART_VERSION
  else
    echo Skipping pmp-revamp-ui installation
  fi

  kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

  echo Installed pms services

  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_pms   # calling function
