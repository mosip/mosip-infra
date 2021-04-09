#!/bin/sh
# Get admin password
echo Password: $(kubectl --kubeconfig ~/.kube/iam_config get secret --namespace keycloak keycloak -o jsonpath="{.data.admin-password}" | base64 --decode)
