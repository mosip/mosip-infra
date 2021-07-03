#!/bin/sh
## Point config to your cluster on which you are installing IAM.
KC="--kubeconfig $HOME/.kube/iam_config" 
NS=keycloak

echo Creating namespace
kubectl $KC create ns keycloak

echo Istio label 
kubectl $KC label ns $NS istio-injection=enabled --overwrite
helm $KC repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

echo Installing 
helm $KC -n $NS install keycloak bitnami/keycloak -f values.yaml

## Set your iam domain
HOST=iam.xyz.net
echo Install Istio gateway, virtual service
helm $KC -n istio-system install istio-addons chart/istio-addons --set keycloakHost=$HOST

