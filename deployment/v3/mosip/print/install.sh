#!/bin/sh
# Installs sample Print service
NS=print
CHART_VERSION=1.1.5

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing print service
helm -n $NS install print-service mosip/print-service --wait --version $CHART_VERSION
