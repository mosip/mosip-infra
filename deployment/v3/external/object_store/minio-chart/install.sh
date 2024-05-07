#!/bin/sh
# Installs minio
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=minio
CHART_VERSION=10.1.6

echo Create namespace
kubectl create ns $NS 

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

echo Installing minio
helm -n $NS install minio mosip/minio --version $CHART_VERSION

echo creating virtual service
kubectl -n $NS apply -f ./vs.yaml

echo installing gateway
kubectl -n $NS apply -f ./gateway.yaml
