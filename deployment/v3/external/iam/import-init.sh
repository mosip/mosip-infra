#!/bin/sh
# Initialize Imported Keycloak with MOSIP base data
# Usage:
# ./import-init.sh [kube_config_file]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=keycloak
CHART_VERSION=12.0.2

helm repo add mosip https://mosip.github.io/mosip-helm
helm repo update

IAM_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-iam-external-host})

echo Initializing keycloak
helm -n $NS install keycloak-init mosip/keycloak-init --set frontend=https://$IAM_HOST/auth -f import-init-values.yaml --version $CHART_VERSION
