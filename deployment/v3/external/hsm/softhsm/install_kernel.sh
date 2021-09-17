#!/bin/sh
# Installs Softhsm for Kernel 
NS=keymanager
STORAGE_CLASS=gp2
CHART_VERSION=1.2.0

echo Create namespaces
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing Softhsm for Kernel
helm -n $NS install softhsm-kernel mosip/softhsm --set fullnameOverride=softhsm-kernel --set persistence.storageClass=$STORAGE_CLASS -f values.yaml --version $CHART_VERSION

