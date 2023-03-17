#!/bin/bash
# Installs packetcreator
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=packetcreator
CHART_VERSION=12.0.1-B3

echo Create $NS namespace
kubectl create ns $NS

function installing_packetcreator() {

  read -p "Please provide NFS host : " NFS_HOST
  read -p "Please provide NFS pem file for SSH login : " NFS_PEM_FILE
  read -p "Please provide user for SSH login : " NFS_USER
  echo -e "[nfs_server]\nnfsserver ansible_user=$NFS_USER ansible_host=$NFS_HOST ansible_ssh_private_key_file=$NFS_PEM_FILE" > hosts.ini
  ansible-playbook -i hosts.ini nfs-server.yaml

  echo "Select the type of Ingress controller to be used (1/2): ";
  echo "1. Ingress";
  echo "2. Istio";
  read -p "" choice

  if [ $choice = "1" ]; then
    list="--set ingress.enabled=true";
  fi

  if [ $choice = "2" ]; then
    list='--set istio.enabled=true';

    echo Istio label
    kubectl label ns $NS istio-injection=enabled --overwrite
    helm repo update
  fi

  echo Installing packetcreator
  helm -n $NS install packetcreator mosip/packetcreator \
  $( echo $list ) \
  --set persistence.nfs.server="$NFS_HOST" \
  --wait --version $CHART_VERSION
  echo Installed packetcreator.
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_packetcreator   # calling function

