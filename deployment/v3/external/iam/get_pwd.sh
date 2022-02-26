#!/bin/sh
# Get admin password
# Usage:
# ./get_pwd.sh [kube_config_file]

if [ $# -ge 1 ]; then
  alias KK="KUBECONFIG=$1 kubectl"
else
  alias KK="KUBECONFIG=$HOME/.kube/iam_config kubectl"
fi
echo Keycloak admin password: $(KK get secret --namespace keycloak keycloak -o jsonpath="{.data.admin-password}" | base64 --decode)
echo mosip-prereg-client password: $(KK get secret --namespace keycloak keycloak-client-secrets -o jsonpath="{.data.preregistration_mosip_prereg_client_secret}" | base64 --decode)

echo mosip-admin-client password: $(KK get secret --namespace keycloak keycloak-client-secrets -o jsonpath="{.data.mosip_mosip_admin_client_secret}" | base64 --decode)

echo Keycloak postgresql password: $(KK get secret --namespace keycloak keycloak-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)

echo Keycloak postgresql postgres password: $(KK get secret --namespace keycloak keycloak-postgresql -o jsonpath="{.data.postgresql-postgres-password}" | base64 --decode)

echo mosip-pms-client password: $(KK get secret --namespace keycloak keycloak-client-secrets -o jsonpath="{.data.mosip_mosip_pms_client_secret}" | base64 --decode)

echo mosip-partner-client password: $(KK get secret --namespace keycloak keycloak-client-secrets -o jsonpath="{.data.mosip_mosip_partner_client_secret}" | base64 --decode)

echo mosip-partnermanager-client password: $(KK get secret --namespace keycloak keycloak-client-secrets -o jsonpath="{.data.mosip_mosip_partnermanager_client_secret}" | base64 --decode)

echo mosip-regproc-client password: $(KK get secret --namespace keycloak keycloak-client-secrets -o jsonpath="{.data.mosip_mosip_regproc_client_secret}" | base64 --decode)

echo mosip-ida-client password: $(KK get secret --namespace keycloak keycloak-client-secrets -o jsonpath="{.data.mosip_mosip_ida_client_secret}" | base64 --decode)
