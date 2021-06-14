#!/bin/sh
# Installs Datashare
NS=datashare

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing Datashare
helm -n $NS install datashare mosip/datashare --wait
