#!/bin/bash
# Installs idrepo
NS=idrepo
CHART_VERSION=1.2.0

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
helm -n $NS install credential mosip/credential --version $CHART_VERSION

echo Running credential request service
helm -n $NS install credentialrequest mosip/credentialrequest --version $CHART_VERSION

echo Running identity service
helm -n $NS install identity mosip/identity --version $CHART_VERSION

echo Running vid service
helm -n $NS install vid mosip/vid --version $CHART_VERSION

