#!/bin/sh
# Copy secrets from other namespaces
# DST_NS: Destination namespace 
COPY_UTIL=../../utils/copy_cm_func.sh
DST_NS=masterdata-loader
$COPY_UTIL secret db-mosip-master-secret db-password $DST_NS
