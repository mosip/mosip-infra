#!/bin/bash
# Copy configmaps from other namespaces
# DST_NS: Destination namespace 

COPY_UTIL=../../utils/copy_cm_func.sh
DST_NS=regclient

$COPY_UTIL configmap artifactory-share artifactory $DST_NS 
