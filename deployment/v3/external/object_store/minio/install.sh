#!/bin/sh
# Installs MinIO inside cluster
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=minio

echo Create namespace $NS
kubectl create namespace $NS
kubectl label ns $NS istio-injection=enabled --overwrite

echo Installing minio
helm -n minio install minio bitnami/minio --version 10.1.6 

echo Installing gateways, vs
EXTERNAL_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-minio-host})

echo host: $EXTERNAL_HOST
helm -n $NS install istio-addons chart/istio-addons --set externalHost=$EXTERNAL_HOST

echo Helm installed. Now run ../cred.sh.
