#!/bin/sh
# Get admin password
echo Keycloak admin password: $(kubectl --kubeconfig ~/.kube/iam_config get secret --namespace keycloak keycloak -o jsonpath="{.data.admin-password}" | base64 --decode)
echo Keycloak prereg client password: $(kubectl --kubeconfig ~/.kube/iam_config get secret --namespace keycloak keycloak-client-secrets -o jsonpath="{.data.preregistration_mosip_prereg_client_secret}" | base64 --decode)
echo Keycloak postgresql password: $(kubectl --kubeconfig ~/.kube/iam_config get secret --namespace keycloak keycloak-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
echo Keycloak postgresql postgres password: $(kubectl --kubeconfig ~/.kube/iam_config get secret --namespace keycloak keycloak-postgresql -o jsonpath="{.data.postgresql-postgres-password}" | base64 --decode)
