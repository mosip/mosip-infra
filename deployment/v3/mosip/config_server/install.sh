#!/bin/sh
# Installs config-server
NS=config-server
echo Copy configmaps
./copy_cm.sh

echo Copy secrets
./copy_secrets.sh

echo Create namespace
kubectl create ns $NS

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing config-server
helm -n $NS install config-server mosip/config-server
