#!/bin/sh
# Copy configmaps.
# DST_NS: Destination namespace 

COPY_UTIL=../../utils/copy_cm_func.sh
DST_NS=artifactory

$COPY_UTIL configmap artifactory-share $DST_NS  $DST_NS artifactory-share-develop
