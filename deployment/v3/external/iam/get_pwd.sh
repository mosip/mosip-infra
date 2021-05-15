#!/bin/sh
# Get admin password
alias KK='kubectl --kubeconfig $HOME/.kube/iam_config'
echo Keycloak admin password: $(KK get secret --namespace keycloak keycloak -o jsonpath="{.data.admin-password}" | base64 --decode)
echo Keycloak prereg client password: $(KK get secret --namespace keycloak keycloak-client-secrets -o jsonpath="{.data.preregistration_mosip_prereg_client_secret}" | base64 --decode)
echo Keycloak postgresql password: $(KK get secret --namespace keycloak keycloak-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
echo Keycloak postgresql postgres password: $(KK get secret --namespace keycloak keycloak-postgresql -o jsonpath="{.data.postgresql-postgres-password}" | base64 --decode)
