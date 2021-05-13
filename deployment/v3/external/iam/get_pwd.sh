#!/bin/sh
# Get admin password
echo Keycloak admin password: $(kubectl --kubeconfig ~/.kube/iam_config get secret --namespace keycloak keycloak -o jsonpath="{.data.admin-password}" | base64 --decode)
