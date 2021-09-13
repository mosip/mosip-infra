#!/bin/sh
# Installs Clamav
NS=clamav
CHART_VERSION=1.2.0

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing Clamav
helm -n $NS install clamav mosip/clamav --set replicaCount=1 --version $CHART_VERSION
