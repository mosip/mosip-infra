#!/bin/sh
# Installs all PreReg helm charts 
NS=prereg

echo Create namespace
kubectl create ns $NS

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing prereg-application
helm -n prereg install prereg-application mosip/prereg-application 

echo Installing prereg-booking
helm -n prereg install prereg-booking mosip/prereg-booking

echo Installing prereg-datasync
helm -n prereg install prereg-datasync mosip/prereg-datasync

echo Installing prereg-batchjob
helm -n prereg install prereg-batchjob mosip/prereg-batchjob

PREREG_API=`kubectl get cm global -o json | jq .data.\"mosip-api-internal-url\" | tr -d '"'`
PREREG_UI=`kubectl get cm global -o json | jq .data.\"mosip-prereg-host\" | tr -d '"'`
echo Installing prereg-ui
helm -n prereg install prereg-ui mosip/prereg-ui --set prereg.apiUrl=$PREREG_API --set istio.hosts[0]=$PREREG_UI
~                                  
