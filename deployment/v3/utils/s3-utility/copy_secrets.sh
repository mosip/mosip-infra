#!/bin/bash
# Copy secrets from other namespaces
# DST_NS: Destination namespace 
COPY_UTIL=../copy_cm_func.sh
DST_NS=s3-utility
$COPY_UTIL secret s3 s3 $DST_NS

