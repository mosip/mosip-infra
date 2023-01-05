#!/bin/bash
# Loads sample masterdata 
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

echo  WARNING: This need to be executed only once at the begining for masterdata deployment. If reexecuted in a working env this will reset the whole master_data DB tables resulting in data loss.
echo  Please skip this if masterdata is already uploaded.
read -p "CAUTION: Do you still want to continue(Y/n)" yn
if [ $yn = "Y" ]
  then
   NS=masterdata-loader
   CHART_VERSION=12.0.1-B2
   helm delete masterdata-loader -n $NS
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
   sed -i 's/\r$//' copy_secrets.sh
   ./copy_secrets.sh

   echo Loading masterdata
   helm -n $NS install masterdata-loader  mosip/masterdata-loader --set mosipDataGithubBranch=1.2.0.1 --version $CHART_VERSION --wait

   else
   break

fi