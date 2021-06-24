#!/bin/sh
# Installs Artifactory
NS=artifactory

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing artifactory
helm -n $NS install artifactory mosip/artifactory 
