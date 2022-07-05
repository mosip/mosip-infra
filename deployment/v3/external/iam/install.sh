#!/bin/sh
## Point config to your cluster on which you are installing IAM.
## "Usage: ./install.sh [kube_config_file]"

RED='\033[0;31m'
NC='\033[0m' # No Color


if [ $# -ge 1 ]; then
  export KUBECONFIG=$1
fi
NS=keycloak

echo Creating $NS namespace
kubectl create ns $NS

echo Istio label
## TODO: enable istio injection after testing well.
kubectl label ns $NS istio-injection=disabled --overwrite
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

echo Installing
helm -n $NS install keycloak bitnami/keycloak --version "7.1.18" --set image.repository=mosipdev/mosip-keycloak --set image.tag=16.1.1-debian-10-r85 -f values.yaml --wait

EXTERNAL_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-iam-external-host})
echo Install Istio gateway, virtual service
helm -n $NS install istio-addons chart/istio-addons --set keycloakExternalHost=$EXTERNAL_HOST --set keycloakInternalHost=keycloak.$NS

echo -e "${RED}Since keycloak is installed now please add Frontend URL's as follows:${NC}"
echo -e "${RED}https://github.com/mosip/mosip-infra/tree/1.2.0.1/deployment/v3/external/iam#frontend-url${NC}"
