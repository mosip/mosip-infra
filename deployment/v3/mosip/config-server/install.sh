#!/bin/bash
# Installs config-server
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=config-server
CHART_VERSION=0.0.2-develop

read -p "Is conf-secrets module installed?(Y/n) " conf_installed

echo "Please select the configuration source for config-server:"
echo "1. Pull configurations from multiple remote repositories (Git)"
echo "2. Pull configurations from local repository (NFS)"
echo "3. Both (Remote Git and Local NFS)"
read -p "Enter your choice (1/2/3) [Default: 1]: " repo_choice

if [[ -z $repo_choice ]]; then
  repo_choice=1
fi

case $repo_choice in
  1)
    SPRING_PROFILES="true"
    LOCALREPO="false"
    ;;
  2)
    SPRING_PROFILES="false"
    LOCALREPO="true"
    ;;
  3)
    SPRING_PROFILES="true"
    LOCALREPO="true"
    ;;
  *)
    echo "Invalid choice. Defaulting to option 1."
    SPRING_PROFILES="true"
    LOCALREPO="false"
    ;;
esac

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
    -f values.yaml \
    --wait --version $CHART_VERSION
    echo "Installed Config-server".
  else
    echo Exiting the MOSIP installation. Please meet the pre-requisites and than start again.
    kill -9 `ps --pid $$ -oppid=`; exit
fi
