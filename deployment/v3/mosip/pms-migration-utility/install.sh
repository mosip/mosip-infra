#!/bin/bash
# Installs all pms migration utility charts
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=pms-migration-utility
CHART_VERSION=12.0.x-develop

echo Create $NS namespace
kubectl create ns $NS

function installing_pms_utility() {
  echo Istio label
  kubectl label ns $NS istio-injection=disabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  read -p "Do you want to run pms-migration-utility as cronjob (Y/n) ?" yn
  CRON=
  CRON_TIME=""
  if [[ $yn == 'Y' ]]; then
    CRON='--set cronjob.enabled=true'
    read -p "Please enter the time(hr) to run the cronjob every \$time hours (time: 0-23) : " time
    if [ -z "$time" ]; then
       echo "ERROT: Time cannot be empty; EXITING;";
       exit 1;
    fi
    if ! [ $time -eq $time ] 2>/dev/null; then
       echo "ERROR: Time $time is not a number; EXITING;";
       exit 1;
    fi
    if [ $time -gt 23 ] || [ $time -lt 0 ] ; then
       echo "ERROR: Time should be in range ( 0-23 ); EXITING;";
       exit 1;
    fi
    CRON_TIME="cronjob.crontime=\"* */$time * * *\""
  fi

  echo "Do you have public domain & valid SSL? (Y/n) "
  echo "Y: if you have public domain & valid ssl certificate"
  echo "n: If you don't have a public domain and a valid SSL certificate. Note: It is recommended to use this option only in development environments."
  read -p "" flag

  if [ -z "$flag" ]; then
    echo "'flag' was provided; EXITING;"
    exit 1;
  fi
  ENABLE_INSECURE=''
  if [ "$flag" = "n" ]; then
    ENABLE_INSECURE='--set enable_insecure=true';
  fi

  echo Installing pms migration utility
  helm -n $NS install pms-migration-utility mosip/pms-migration-utility \
  $CRON --set-string="${CRON_TIME}" \
  $ENABLE_INSECURE \
  --wait --wait-for-jobs \
  --version $CHART_VERSION

  echo Installed pms-migration-utility
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_pms_utility   # calling function
