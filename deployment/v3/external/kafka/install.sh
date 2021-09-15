#!/bin/bash
# Installs kafka
NS=kafka

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing kafka
helm -n kafka install kafka bitnami/kafka -f values.yaml
