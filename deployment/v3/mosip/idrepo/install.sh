#!/bin/sh
# Installs idrepo
NS=idrepo

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Running salt generator job
helm -n $NS install idrepo-saltgen  mosip/idrepo-saltgen --wait --wait-for-jobs

echo Running credential
helm -n $NS install credential mosip/credential

echo Running credential request service
helm -n $NS install credentialrequest mosip/credentialrequest

echo Running identity service
helm -n $NS install identity mosip/identity

echo Running vid service
helm -n $NS install vid mosip/vid

