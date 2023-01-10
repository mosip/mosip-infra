#!/bin/bash
# All keycloak secrets as seen by config server. Note that source of keycloak secrets is in keycloak namespace
# the secrets here are copy of the original.  They must match.  This script is more for debugging if there some
# mismatch.
echo Keycloak admin password: $(kubectl get secret --namespace config-server keycloak  -o jsonpath="{.data.admin-password}" | base64 --decode)
echo Keycloak preregistration client password: $(kubectl get secret --namespace config-server keycloak-client-secrets  -o jsonpath="{.data.preregistration_mosip_prereg_client_secret}" | base64 --decode)
echo Keycloak mosip-admin-client password: $(kubectl get secret --namespace config-server keycloak-client-secrets  -o jsonpath="{.data.mosip_mosip_admin_client_secret}" | base64 --decode)
