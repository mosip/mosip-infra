#!/bin/bash
# Copy secrets from other namespaces
# DST_NS: Destination namespace

COPY_UTIL=../../utils/copy_cm_func.sh
DST_NS=onboarder

$COPY_UTIL secret s3 s3 $DST_NS
$COPY_UTIL secret keycloak keycloak $DST_NS
$COPY_UTIL secret keycloak-client-secrets keycloak $DST_NS
