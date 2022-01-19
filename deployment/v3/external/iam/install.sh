#!/bin/sh
## Point config to your cluster on which you are installing IAM.
if [ $# -lt 1 ]; then
  echo "Usage: ./install.sh <iam host name for this install> [kube_config_file]"; exit 1
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
## TODO: enable istio injection after testing well.
kubectl label ns $NS istio-injection=disabled --overwrite
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

echo Installing
helm -n $NS install keycloak bitnami/keycloak --version "4.3.0" -f values.yaml

## Set your iam domain
HOST=$1
echo Install Istio gateway, virtual service
helm -n $NS install istio-addons chart/istio-addons --set keycloakExternalHost=$HOST --set keycloakInternalHost=keycloak.$NS
