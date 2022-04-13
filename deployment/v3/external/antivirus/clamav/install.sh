#!/bin/sh
# Installs Clamav
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=clamav

echo Create $NS namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo add wiremind https://wiremind.github.io/wiremind-helm-charts
helm repo update

echo Installing Clamav
helm -n $NS install clamav wiremind/clamav -f values.yaml

echo ClamAV installed sucessfully
