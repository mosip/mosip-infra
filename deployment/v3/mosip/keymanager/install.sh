#!/bin/sh
# Installs Keymanager
NS=keymanager

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Running keygenerator
helm -n $NS install kernel-keygen mosip/kernel-keygen --wait-for-jobs

echo Installing keymanager
helm -n $NS install keymanager mosip/keymanager

