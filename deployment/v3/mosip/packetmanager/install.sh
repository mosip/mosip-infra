#!/bin/sh
# Installs packetmanager
NS=packetmanager

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing packetmanager
helm -n $NS install packetmanager mosip/packetmanager
