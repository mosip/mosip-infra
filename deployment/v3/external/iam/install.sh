#!/bin/sh
CLUSTER_CONFIG=$HOME/.kube/iam_config
helm --kubeconfig $CLUSTER_CONFIG repo add bitnami https://charts.bitnami.com/bitnami
kubectl --kubeconfig $CLUSTER_CONFIG create ns keycloak
helm --kubeconfig $CLUSTER_CONFIG -n keycloak install keycloak bitnami/keycloak -f values.yaml
