#!/bin/bash
# Copy configmaps from other namespaces
# DST_NS: Destination namespace 
COPY_UTIL=../../utils/copy_cm_func.sh
DST_NS=abis

$COPY_UTIL configmap global default $DST_NS 
$COPY_UTIL configmap config-server-share config-server $DST_NS 




