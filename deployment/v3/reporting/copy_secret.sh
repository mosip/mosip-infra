#!/bin/sh
# Copy configmaps from other namespaces
# DST_NS: Destination (current) namespace 
COPY_UTIL=../utils/copy_cm_func.sh
DST_NS=$1

$COPY_UTIL secret db-common-secrets postgres $DST_NS $2
