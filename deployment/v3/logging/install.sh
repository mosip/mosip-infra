#!/bin/sh
# Installs Elasticsearch
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=cattle-logging-system

echo Create namespace logging
kubectl create namespace $NS

echo Updating helm repos
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

echo Installing Bitnami Elasticsearch and Kibana
helm -n $NS install elasticsearch bitnami/elasticsearch -f es_values.yaml --wait

KIBANA_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-kibana-host})
KIBANA_NAME=kibana

echo Install istio addons
helm -n $NS install istio-addons chart/istio-addons --set kibanaHost=$KIBANA_HOST --set installName=$KIBANA_NAME
