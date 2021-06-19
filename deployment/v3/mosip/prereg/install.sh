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
helm -n $NS install prereg-application mosip/prereg-application 

echo Installing prereg-booking
helm -n $NS install prereg-booking mosip/prereg-booking

echo Installing prereg-datasync
helm -n $NS install prereg-datasync mosip/prereg-datasync

echo Installing prereg-batchjob
helm -n $NS install prereg-batchjob mosip/prereg-batchjob

API_HOST=`kubectl get cm global -o json | jq .data.\"mosip-api-internal-host\" | tr -d '"'`
PREREG_UI=`kubectl get cm global -o json | jq .data.\"mosip-prereg-host\" | tr -d '"'`
echo Installing prereg-ui
helm -n $NS install prereg-ui mosip/prereg-ui --set prereg.apiHost=$API_HOST --set istio.hosts[0]=$PREREG_UI


~                                  
