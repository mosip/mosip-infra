#!/bin/bash
# Installs config-server
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=config-server
CHART_VERSION=0.0.2-develop

read -p "Is conf-secrets module installed?(Y/n) " conf_installed
read -p "Do you want to enable config-server to pull configurations from multiple repositories?(Y/n)( Default: n )" comp_enabled
if [[ -z $comp_enabled ]]; then
  comp_enabled=n
fi
if [ "$comp_enabled" = "Y" ]; then
  COMPOSITE_PROFILES="true"
else
  COMPOSITE_PROFILES="false"
fi

read -p "Do you want to enable config-server to pull configurations from local repository?(Y/n)( Default: n )" local_enabled
if [[ -z $local_enabled ]]; then
  local_enabled=n
fi

if [ "$local_enabled" = "Y" ]; then
  LOCALREPO="true"
  read -p "Provide the NFS path where the local repository is cloned/maintained: " path
  NFS_PATH="$path"

  read -p "Provide the NFS IP address of the server where the local repository is cloned: " ip
  NFS_SERVER="$ip"
else
  LOCALREPO="false"
  NFS_PATH=""
  NFS_SERVER=""
fi

if [ $conf_installed = "Y" ]; then read -p "Is values.yaml for config-server chart set correctly as part of Pre-requisites?(Y/n) " yn; fi
if [ $yn = "Y" ]
  then
    echo Create $NS namespace
    kubectl create ns $NS

    # set commands for error handling.
    set -e
    set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
    set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
    set -o errtrace  # trace ERR through 'time command' and other functions
    set -o pipefail  # trace ERR through pipes

    echo Istio label
    kubectl label ns $NS istio-injection=enabled --overwrite
    helm repo update

    echo Copy configmaps
    sed -i 's/\r$//' copy_cm.sh
    ./copy_cm.sh

    echo Copy secrets
    sed -i 's/\r$//' copy_secrets.sh
    ./copy_secrets.sh

    echo "Installing config-server"
    helm -n $NS install config-server mosip/config-server \
    --set spring_profiles.enabled="$COMPOSITE_PROFILES" \
    --set localRepo.enabled="$LOCALREPO" \
    --set volume.nfs.path="$NFS_PATH" \
    --set volume.nfs.server="$NFS_SERVER" \
    -f values.yaml \
    --wait --version $CHART_VERSION
    echo "Installed Config-server".
  else
    echo Exiting the MOSIP installation. Please meet the pre-requisites and than start again.
    kill -9 `ps --pid $$ -oppid=`; exit
fi
