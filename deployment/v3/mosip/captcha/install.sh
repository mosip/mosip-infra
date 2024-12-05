#!/bin/bash
## Installing captcha validation server.
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=captcha
CHART_VERSION=0.0.1-develop

function installing_captcha() {

  while true; do
      read -p "Do you want to continue installing captcha validation service? (y/n): " ans
      if [ "$ans" = "Y" ] || [ "$ans" = "y" ]; then
          break
      elif [ "$ans" = "N" ] || [ "$ans" = "n" ]; then
          exit 1
      else
          echo "Please provide a correct option (Y or N)"
      fi
  done

  NS=captcha
  CHART_VERSION=0.1.0-develop

  echo Create $NS namespace
  kubectl create ns $NS || true

  echo Istio label

  kubectl label ns $NS istio-injection=disabled --overwrite
  helm repo update

  while true; do
    read -p "Is Prometheus Service Monitor Operator deployed in the k8s cluster? (y/n): " response
    if [[ "$response" == "y" || "$response" == "Y" ]]; then
      servicemonitorflag=true
      break
    elif [[ "$response" == "n" || "$response" == "N" ]]; then
      servicemonitorflag=false
      break
    else
      echo "Not a correct response. Please respond with y (yes) or n (no)."
    fi
  done

  echo Installing captcha
  helm -n $NS install captcha mosip/captcha --version $CHART_VERSION --set metrics.serviceMonitor.enabled=$servicemonitorflag --wait

  echo Installed captcha service



  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_captcha
