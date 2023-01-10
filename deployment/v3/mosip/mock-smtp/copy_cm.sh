#!/bin/bash
# Copy configmaps from other namespaces
# DST_NS: Destination namespace
COPY_UTIL=../../utils/copy_cm_func.sh
DST_NS=mock-smtp

$COPY_UTIL configmap global default $DST_NS
