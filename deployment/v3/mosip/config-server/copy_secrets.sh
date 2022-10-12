#!/bin/sh
# Copy secrets from other namespaces
# DST_NS: Destination namespace 
COPY_UTIL=../../utils/copy_cm_func.sh
DST_NS=config-server
$COPY_UTIL secret keycloak keycloak $DST_NS
$COPY_UTIL secret keycloak-client-secrets keycloak $DST_NS
$COPY_UTIL secret activemq-activemq-artemis activemq $DST_NS
$COPY_UTIL secret softhsm-kernel softhsm $DST_NS
$COPY_UTIL secret softhsm-ida softhsm $DST_NS
$COPY_UTIL secret softhsm-idp softhsm $DST_NS
$COPY_UTIL secret s3 s3 $DST_NS
$COPY_UTIL secret email-gateway msg-gateways $DST_NS
$COPY_UTIL secret prereg-captcha prereg $DST_NS
$COPY_UTIL secret conf-secrets-various conf-secrets $DST_NS

SECRET_REGEX='db-.*-secret'
secrets_list=$(kubectl get secrets -n db-password --no-headers -o custom-columns=':.metadata.name' | grep "$SECRET_REGEX")
for secret in $secrets_list; do
  $COPY_UTIL secret $secret db-password $DST_NS
done