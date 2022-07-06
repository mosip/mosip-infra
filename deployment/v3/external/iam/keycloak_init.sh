#!/bin/sh
# Initialize Keycloak with MOSIP base data
# Usage:
# ./keycloak_init.sh [kube_config_file]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=keycloak
CHART_VERSION=12.0.2

helm repo add mosip https://mosip.github.io/mosip-helm
helm repo update

IAMHOST_URL=$(kubectl get cm global -o jsonpath={.data.mosip-iam-external-host})

echo Initializing keycloak
helm -n $NS install keycloak-init mosip/keycloak-init --set frontend=https://$IAMHOST_URL/auth --version 12.0.2
