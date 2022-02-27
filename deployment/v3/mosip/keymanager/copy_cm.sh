#!/bin/sh
# Copy configmaps from other namespaces
# DST_NS: Destination (current) namespace 
COPY_UTIL=../../utils/copy_cm_func.sh
DST_NS=keymanager

$COPY_UTIL configmap global default $DST_NS 
$COPY_UTIL configmap artifactory-share artifactory $DST_NS 
$COPY_UTIL configmap config-server-share config-server $DST_NS
$COPY_UTIL configmap softhsm softhsm-kernel $DST_NS
$COPY_UTIL configmap softhsm-share softhsm-kernel $DST_NS softhsm-kernel-share
