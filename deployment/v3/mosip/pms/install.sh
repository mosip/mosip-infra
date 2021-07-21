#!/bin/sh
# Installs all PMS charts
NS=pms

echo Create namespace
kubectl create ns $NS

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing partner manager
helm -n $NS install pms-partner mosip/pms-partner -f values.yaml

echo Installing policy manager
helm -n $NS install pms-policy mosip/pms-policy
