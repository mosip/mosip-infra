#!/bin/sh
## Script to install Keycloak for Rancher
## Usage: ./install.sh <iam_host_name> [kube_config_file]
## iam_host_name: Example iam.mosip.net

if [ $# -lt 1 ]; then
  echo "Usage: ./install.sh <iam_host_name> [kube_config_file]"; exit 1
fi
if [ $# -ge 2 ]; then
  export KUBECONFIG=$2
else
  export KUBECONFIG="$HOME/.kube/iam_config"
fi
NS=keycloak

echo Creating namespace
kubectl create ns keycloak

echo Istio label
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

echo Installing
helm -n $NS install keycloak bitnami/keycloak --version "4.3.0" -f values.yaml --set ingress.hostname=$1

