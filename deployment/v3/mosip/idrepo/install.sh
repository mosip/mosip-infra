#!/bin/sh
# Installs idrepo
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=idrepo
CHART_VERSION=1.1.5

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Running salt generator job
helm -n $NS install idrepo-saltgen  mosip/idrepo-saltgen --wait --wait-for-jobs --version $CHART_VERSION

echo Running credential
helm -n $NS install credential mosip/credential -f cred-values.yaml --version $CHART_VERSION

echo Running credential request service
helm -n $NS install credentialrequest mosip/credentialrequest -f credreq-values.yaml --version $CHART_VERSION

echo Running identity service
helm -n $NS install identity mosip/identity -f identity-values.yaml --version $CHART_VERSION

echo Running vid service
helm -n $NS install vid mosip/vid -f vid-values.yaml --version $CHART_VERSION

