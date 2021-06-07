#!/bin/sh
# Installs Keymanager
NS=keymanager
echo Copy configmaps
./copy_cm.sh

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing keymanager
helm -n $NS install keymanager mosip/keymanager
