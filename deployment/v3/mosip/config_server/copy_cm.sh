#!/bin/bash
# Copy configmaps from other namespaces
# DST_NS: Destination namespace 
# Change OBJECT_STORE to "minio" if you are using the same for object store
COPY_UTIL=../../utils/copy_cm_func.sh
DST_NS=config-server
OBJECT_STORE=s3
$COPY_UTIL configmap global default $DST_NS 
$COPY_UTIL configmap keycloak-host keycloak $DST_NS ~/.kube/iam_config
$COPY_UTIL configmap activemq-activemq-artemis-share activemq $DST_NS
$COPY_UTIL configmap s3 s3 $DST_NS
$COPY_UTIL configmap email-gateway msg-gateways $DST_NS
