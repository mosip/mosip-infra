#!/bin/sh
# Installs Websub
NS=websub

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Copy secrets
./copy_secrets.sh

echo Installing Websub
helm -n $NS install websub mosip/websub -f values.yaml --wait
