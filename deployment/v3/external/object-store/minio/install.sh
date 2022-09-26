#!/bin/sh
# Installs MinIO using helm chart inside MOSIP cluster
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=minio

echo Create $NS namespace
kubectl create ns $NS
kubectl label ns $NS istio-injection=enabled --overwrite

echo Installing minio
helm -n minio install minio bitnami/minio -f values.yaml --version 10.1.6 

echo Installing gateways and virtualservice
EXTERNAL_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-minio-host})

echo host: $EXTERNAL_HOST
helm -n $NS install istio-addons chart/istio-addons --set externalHost=$EXTERNAL_HOST

echo Helm installed. Next step is to execute the cred.sh to update secrets in s3 namespace
