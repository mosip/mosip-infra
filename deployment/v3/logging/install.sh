#!/bin/bash
# Installs Elasticsearch
NS=cattle-logging-system

echo Create namespace logging
kubectl create namespace $NS

echo Installing Bitnami Elasticsearch
helm -n $NS install elasticsearch bitnami/elasticsearch -f es_values.yaml --wait

KIBANA_HOST=`kubectl get cm global -o json | jq .data.\"mosip-kibana-host\" | tr -d '"'`
KIBANA_NAME=mykibana
echo Installing Kibana
helm -n $NS install $KIBANA_NAME bitnami/kibana -f kibana_values.yaml --wait

echo Install istio addons
helm -n $NS install istio-addons chart/istio-addons --set kibanaHost=$KIBANA_HOST --set installName=$KIBANA_NAME
