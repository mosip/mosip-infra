#!/bin/bash
# Installs key-migration-utility
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=key-migration-utility
CHART_VERSION=0.0.1-develop

echo Creating $NS namespace
kubectl create ns $NS

function installing_key_migration_utility() {

  helm repo update

  read -p "please provide module name for migration (ex: kernel, ida, esignet, etc.) : " module

  if [[ -z $module ]]; then
    echo "module is empty; EXITING;"
    exit 0
  fi

  read -p "please provide properties file name (ex: migration ) : " config_prop

  if [[ -z $config_prop ]]; then
    echo "config properties is empty; EXITING;"
    exit 0
  fi

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh $module

  echo Installing key-migration-utility
  helm -n $NS install key-migration-utility-$module mosip/key-migration-utility \
  --set softHsmCM=softhsm-$module-share \
  --set springConfigNameEnv=$config_prop \
  --wait --wait-for-jobs \
  --version $CHART_VERSION

  echo Installed key-migration-utility services
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_key_migration_utility   # calling function
