#!/bin/sh
# Copy secrets from other namespaces
# DST_NS: Destination namespace 
COPY_UTIL=../../utils/copy_cm_func.sh
DST_NS=websub

$COPY_UTIL secret db-common-secrets postgres $DST_NS 


