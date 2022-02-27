#!/bin/sh
# Installs Websub
NS=websub
CHART_VERSION=1.2.0

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing Websub
helm -n $NS install websub-consolidator mosip/websub-consolidator -f consolidator-values.yaml --version $CHART_VERSION --wait
helm -n $NS install websub mosip/websub -f websub-values.yaml --version $CHART_VERSION
