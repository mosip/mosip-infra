#!/bin/bash
# Copy secrets from other namespaces
# DST_NS: Destination namespace
COPY_UTIL=../../utils/copy_cm_func.sh
DST_NS=resident

$COPY_UTIL secret keycloak-client-secrets keycloak $DST_NS
