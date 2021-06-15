#!/bin/sh
# Installs sample Print service
NS=print

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing print service
helm -n $NS install print-service mosip/print-service --wait
