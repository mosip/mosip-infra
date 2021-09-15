#!/bin/bash
# Installs BioSDK
NS=biosdk
CHART_VERSION=1.1.5

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing Biosdk server
helm -n $NS install biosdk-service mosip/biosdk-service -f values.yaml --version $CHART_VERSION
