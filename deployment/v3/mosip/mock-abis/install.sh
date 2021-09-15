#!/bin/bash
# Installs Mock ABIS
NS=abis
CHART_VERSION=1.1.5

echo Create namespace
kubectl create ns $NS 

echo Copy configmaps
./copy_cm.sh

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing Mock ABIS
helm -n $NS install mock-abis mosip/mock-abis --version $CHART_VERSION
