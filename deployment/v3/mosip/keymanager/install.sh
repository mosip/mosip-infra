#!/bin/sh
# Installs Keymanager
NS=keymanager

echo Istio label
kubectl label ns $NS istio-injection=enabled --overwrite
kubectl apply -n $NS -f idle_timeout_envoyfilter.yaml
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Running keygenerator
helm -n $NS install kernel-keygen mosip/kernel-keygen --wait --wait-for-jobs

echo Installing keymanager
helm -n $NS install keymanager mosip/keymanager
