#!/usr/bin/env bash
# Installs config-server secrets
## Usage: ./install_secrets.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=conf-secrets
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo "Installing Secrets required by config-server"
helm -n $NS install conf-secrets mosip/conf-secrets --wait
