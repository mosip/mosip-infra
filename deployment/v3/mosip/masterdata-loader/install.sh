#!/bin/sh
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
   CHART_VERSION=12.0.1

   echo Create $NS namespace
   kubectl create ns $NS

   echo Istio label
   kubectl label ns $NS istio-injection=enabled --overwrite
   helm repo update

   echo Copy configmaps
   ./copy_secrets.sh

   echo Loading masterdata
   helm -n $NS install masterdata-loader  mosip/masterdata-loader --set mosipDataGithubBranch=develop --version $CHART_VERSION --wait

   else
   break

fi
