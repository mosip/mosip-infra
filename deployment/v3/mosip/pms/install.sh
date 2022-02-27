#!/bin/sh
# Installs all PMS charts
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=pms
CHART_VERSION=1.1.5

echo Create namespace
kubectl create ns $NS

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing partner manager
helm -n $NS install pms-partner mosip/pms-partner -f partner-values.yaml --version $CHART_VERSION

echo Installing policy manager
helm -n $NS install pms-policy mosip/pms-policy -f policy-values.yaml --version $CHART_VERSION
