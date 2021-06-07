#!/bin/sh
# Installs Mock ABIS
NS=abis
echo Copy configmaps
./copy_cm.sh

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing Mock ABIS
helm -n $NS install mock-abis mosip/mosip-abis
