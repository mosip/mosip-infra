#!/bin/bash
# Installs all prereg helm charts
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=prereg
CHART_VERSION=12.0.1

echo Create $NS namespace
kubectl create ns $NS

function installing_prereg() {
  echo Istio label
  ## TODO: Istio proxy disabled for now as prereui does not come up if
  ## envoy filter container gets installed after prereg container.
  kubectl label ns $NS istio-injection=disabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  API_HOST=`kubectl get cm global -o jsonpath={.data.mosip-api-host}`
  PREREG_HOST=`kubectl get cm global -o jsonpath={.data.mosip-prereg-host}`

  echo Install prereg-gateway
  helm -n $NS install prereg-gateway mosip/prereg-gateway --set istio.hosts[0]=$PREREG_HOST --version $CHART_VERSION

  echo Installing prereg-application
  helm -n $NS install prereg-application mosip/prereg-application --version $CHART_VERSION

  echo Installing prereg-booking
  helm -n $NS install prereg-booking mosip/prereg-booking --version $CHART_VERSION

  echo Installing prereg-datasync
  helm -n $NS install prereg-datasync mosip/prereg-datasync --version $CHART_VERSION

  echo Installing prereg-batchjob
  helm -n $NS install prereg-batchjob mosip/prereg-batchjob --version $CHART_VERSION

  echo Installing prereg-ui
  helm -n $NS install prereg-ui mosip/prereg-ui --set prereg.apiHost=$PREREG_HOST --version $CHART_VERSION

  if [[ -z "$ENV_VAR_EXISTS" ]]; then
      # If the environment variable does not exist, add it
      echo "Environment variable 'MOSIP_CAPTCHA' does not exist. Adding it..."
      kubectl patch deployment -n captcha captcha --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/env/-", "value": {"name": "MOSIP_CAPTCHA", "valueFrom": {"secretKeyRef": {"name": "mosip-captcha", "key": "prereg-captcha-secret-key"}}}}]'
  else
      # If the environment variable exists, update it
      echo "Environment variable 'MOSIP_CAPTCHA' exists. Updating it..."
      kubectl patch deployment -n captcha captcha --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/env[?(@.name==\"MOSIP_CAPTCHA\")]", "value": {"name": "MOSIP_CAPTCHA", "valueFrom": {"secretKeyRef": {"name": "mosip-captcha", "key": "prereg-captcha-secret-key"}}}}]'
  fi

  echo Installing prereg rate-control Envoyfilter
  kubectl apply -n $NS -f rate-control-envoyfilter.yaml

  kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

  echo Installed prereg services
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_prereg   # calling function
