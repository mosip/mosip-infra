#!/bin/sh
helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create ns keycloak
helm -n keycloak install keycloak bitnami/keycloak -f values.yaml
