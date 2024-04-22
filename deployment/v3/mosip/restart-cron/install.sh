#!/bin/bash
# Installs restart-cron
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=infra-admin
CHART_VERSION=12.0.x-develop

echo Create $NS namespace
kubectl create ns $NS

function installing_restart-cron() {
  echo "This script installs cronjob which restarts packetcreator, Idgenerator and authdemo service and other services based on configurations in value.yaml file, Do you want to install? (Y/n) "
  echo "Y: if you wish to install this cronjob in your cluster"
  echo "n: if you don't want to install this cronjob in your cluster"
  read -p "" flag

  if [ -z "$flag" ]; then
    echo "'flag' was provided; EXITING;"
    exit 1;
  fi

  read -p "Is values.yaml for restart-cron chart set correctly as part of Pre-requisites?(Y/n) " yn;
  if [ $yn = "Y" ]; then

  echo Istio label
  kubectl label ns $NS istio-injection=disabled --overwrite
  helm repo update

  echo Installing restart-cron idgenerator
  helm -n $NS install restart-cron mosip/restart-cron \
  --set schedule.crontime="0 */4 * * 1-5" \
  -f values.yaml \
  --version $CHART_VERSION
  echo Installed restart-cron.
  return 0
  fi
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_restart-cron   # calling function
