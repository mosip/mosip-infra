#!/bin/bash
# Initialize Keycloak with MOSIP base data
KC="--kubeconfig $HOME/.kube/iam_config" 
NS=keycloak
CHART_VERSION=1.1.5

helm $KC repo add mosip https://mosip.github.io/mosip-helm
helm $KC repo update

echo Initializing keycloak
helm $KC -n $NS install keycloak-init mosip/keycloak-init --version $CHART_VERSION

