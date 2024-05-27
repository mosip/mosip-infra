#!/bin/bash
# Installs keymanager
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=keymanager
CHART_VERSION=0.0.1-develop

echo Creating $NS namespace
kubectl create ns $NS

function installing_keymanager() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  kubectl apply -n $NS -f idle_timeout_envoyfilter.yaml
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  default_enable_volume=false
  read -p "Would you like to enable volume (true/false) : [ default : false ] : " enable_volume
  enable_volume=${enable_volume:-$default_enable_volume}

  KERNEL_KEYGEN_HELM_ARGS='--set springConfigNameEnv="kernel" --set softHsmCM="softhsm-kernel-share"'
  KERNEL_HELM_ARGS=''
  if [[ $enable_volume == 'true' ]]; then

    default_volume_size=100M
    read -p "Provide the size for volume [ default : 100M ]" volume_size
    volume_size=${volume_size:-$default_volume_size}

    default_volume_mount_path='/home/mosip/config/'
    read -p "Provide the mount path for volume [ default : '/home/mosip/config/' ] : " volume_mount_path
    volume_mount_path=${volume_mount_path:-$default_volume_mount_path}

    PVC_CLAIM_NAME='kernel-keygen-keymanager'
    KERNEL_KEYGEN_HELM_ARGS="--set persistence.enabled=true  \
               --set volumePermissions.enabled=true \
               --set persistence.size=$volume_size \
               --set persistence.mountDir=\"$volume_mount_path\" \
               --set springConfigNameEnv='kernel' \
               --set persistence.pvc_claim_name=\"$PVC_CLAIM_NAME\"  \
              "
    KERNEL_HELM_ARGS="--set persistence.enabled=true  \
                   --set volumePermissions.enabled=true \
                   --set persistence.mountDir=\"$volume_mount_path\" \
                   --set persistence.existingClaim=\"$PVC_CLAIM_NAME\"  \
                   --set extraEnvVarsCM={'global','config-server-share','artifactory-share'} \
                  "
  fi
  echo "KERNEL KEYGEN HELM ARGS $KERNEL_KEYGEN_HELM_ARGS"
  echo "KERNEL HELM ARGS $KERNEL_HELM_ARGS"

  echo Running keygenerator. This may take a few minutes..
  helm -n $NS install kernel-keygen mosip/keygen  $KERNEL_KEYGEN_HELM_ARGS --wait --wait-for-jobs --version $CHART_VERSION

  echo Installing keymanager
  helm -n $NS install keymanager mosip/keymanager $KERNEL_HELM_ARGS --wait --version $CHART_VERSION

  kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status
  echo Installed keymanager services
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_keymanager   # calling function
