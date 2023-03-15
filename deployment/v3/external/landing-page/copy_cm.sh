#!/bin/bash
# Copy configmaps from other namespaces
# DST_NS: Destination namespace

sed -i 's/\r$//' ../../utils/copy_cm_func.sh
COPY_UTIL=../../utils/copy_cm_func.sh
DST_NS=landing-page

$COPY_UTIL configmap global default $DST_NS