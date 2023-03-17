#!/bin/bash
# Installs authdemo
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=authdemo
CHART_VERSION=12.0.1-B3

echo Create $NS namespace
kubectl create ns $NS


function installing_authdemo() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Copy configmaps
  ./copy_cm.sh

  echo Copy secrets
  ./copy_secrets.sh

  echo "Do you have public domain & valid SSL? (Y/n) "
  echo "Y: if you have public domain & valid ssl certificate"
  echo "n: if you don't have public domain & valid ssl certificate"
  read -p "" flag

  if [ -z "$flag" ]; then
    echo "'flag' was provided; EXITING;"
    exit 1;
  fi
  ENABLE_INSECURE=''
  if [ "$flag" = "n" ]; then
    ENABLE_INSECURE='--set authdemo.configmaps.authdemo.ENABLE_INSECURE=true';
  fi

  read -p "Please provide NFS host : " NFS_HOST
  read -p "Please provide NFS pem file for SSH login : " NFS_PEM_FILE
  read -p "Please provide user for SSH login : " NFS_USER
  echo -e "[nfs_server]\nnfsserver ansible_user=$NFS_USER ansible_host=$NFS_HOST ansible_ssh_private_key_file=$NFS_PEM_FILE" > hosts.ini
  ansible-playbook -i hosts.ini nfs-server.yaml


  echo Installing authdemo
  helm -n $NS install authdemo mosip/authdemo $ENABLE_INSECURE \
  --set persistence.nfs.server="$NFS_HOST" \
  --version $CHART_VERSION --wait

  echo Installed authdemo.
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_authdemo   # calling function
