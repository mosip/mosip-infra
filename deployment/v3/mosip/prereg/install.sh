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

PREREG_HOST=`kubectl get cm global -o json | jq .data.\"mosip-api-url\" | tr -d '"'`
echo Installing prereg-ui
helm -n prereg install prereg-ui mosip/prereg-ui --set prereg.host=$PREREG_HOST
