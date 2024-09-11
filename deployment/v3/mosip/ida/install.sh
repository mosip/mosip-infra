#!/bin/bash
# Installs all ida helm charts 
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=ida
CHART_VERSION=0.0.1-develop

echo Create $NS namespace
kubectl create ns $NS

function installing_ida() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

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

  default_enable_volume=false
  read -p "Would you like to enable volume (true/false) : [ default : false ] : " enable_volume
  enable_volume=${enable_volume:-$default_enable_volume}

  IDA_KEYGEN_HELM_ARGS='--set springConfigNameEnv="id-authentication" --set softHsmCM="softhsm-ida-share"'
  IDA_HELM_ARGS=''
  if [[ $enable_volume == 'true' ]]; then

    default_volume_size=100M
    read -p "Provide the size for volume [ default : 100M ]" volume_size
    volume_size=${volume_size:-$default_volume_size}

    default_volume_mount_path='/home/mosip/config/'
    read -p "Provide the mount path for volume [ default : '/home/mosip/config/' ] : " volume_mount_path
    volume_mount_path=${volume_mount_path:-$default_volume_mount_path}

    PVC_CLAIM_NAME='ida-keygen-keymanager'
    IDA_KEYGEN_HELM_ARGS="--set persistence.enabled=true  \
               --set volumePermissions.enabled=true \
               --set persistence.size=$volume_size \
               --set persistence.mountDir=\"$volume_mount_path\" \
               --set springConfigNameEnv='id-authentication' \
               --set persistence.pvc_claim_name=\"$PVC_CLAIM_NAME\"  \
              "
    IDA_HELM_ARGS="--set persistence.enabled=true  \
                   --set volumePermissions.enabled=true \
                   --set persistence.mountDir=\"$volume_mount_path\" \
                   --set persistence.existingClaim=\"$PVC_CLAIM_NAME\"  \
                   --set extraEnvVarsCM={'global','config-server-share','artifactory-share'} \
                  "
  fi
  echo "IDA KEYGEN HELM ARGS $IDA_KEYGEN_HELM_ARGS"
  echo "IDA HELM ARGS $IDA_HELM_ARGS"

  echo Running ida keygen
  helm -n $NS install ida-keygen mosip/keygen $IDA_KEYGEN_HELM_ARGS --wait --wait-for-jobs  --version $CHART_VERSION

  echo Installing ida auth
  helm -n $NS install ida-auth mosip/ida-auth $IDA_HELM_ARGS --version $CHART_VERSION $ENABLE_INSECURE

  echo Installing ida internal
  helm -n $NS install ida-internal mosip/ida-internal $IDA_HELM_ARGS --version $CHART_VERSION $ENABLE_INSECURE

  echo Installing ida otp
  helm -n $NS install ida-otp mosip/ida-otp $IDA_HELM_ARGS --version $CHART_VERSION $ENABLE_INSECURE

  kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

  echo Installed ida services
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_ida   # calling function
