#!/bin/sh
# Installs Clamav
NS=clamav

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing Clamav
helm -n clamav install clamav mosip/clamav --set replicaCount=1
