#!/bin/sh
# Initialize Keycloak with MOSIP base data
# Usage:
# ./keycloak_init.sh [kube_config_file]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=keycloak
CHART_VERSION=1.2.0

helm repo add mosip https://mosip.github.io/mosip-helm
helm repo update

echo Initializing keycloak
helm -n $NS install keycloak-init mosip/keycloak-init --version $CHART_VERSION
