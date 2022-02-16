#!/bin/sh
## Point config to your cluster on which you are installing IAM.
## "Usage: ./install.sh [kube_config_file]"

if [ $# -ge 1 ]; then
  export KUBECONFIG=$1
else
  export KUBECONFIG="$HOME/.kube/config"
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

EXTERNAL_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-iam-external-host})
echo Install Istio gateway, virtual service
helm -n $NS install istio-addons chart/istio-addons --set keycloakExternalHost=$EXTERNAL_HOST --set keycloakInternalHost=keycloak.$NS
