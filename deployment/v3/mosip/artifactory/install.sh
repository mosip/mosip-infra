#!/bin/bash
# Installs Artifactory
NS=artifactory
CHART_VERSION=1.1.5

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing artifactory
helm -n $NS install artifactory mosip/artifactory --version $CHART_VERSION 
