#!/bin/sh
# Copy secrets from other namespaces
# DST_NS: Destination namespace 
COPY_UTIL=../../utils/copy_cm_func.sh
DST_NS=config-server

$COPY_UTIL secret db-common-secrets postgres $DST_NS 
$COPY_UTIL secret keycloak keycloak $DST_NS ~/.kube/iam_config
$COPY_UTIL secret keycloak-client-secrets keycloak $DST_NS ~/.kube/iam_config
$COPY_UTIL secret softhsm-kernel softhsm $DST_NS 
$COPY_UTIL secret activemq-activemq-artemis activemq $DST_NS 
# If IDA is installed
#$COPY_UTIL secret softhsm-ida softhsm $DST_NS 


