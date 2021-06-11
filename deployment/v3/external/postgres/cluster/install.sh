#!/bin/sh
# Installs postgres inside the cluster
NS=postgres

echo Create namespace postgres
kubectl create namespace postgres
kubectl label ns $NS istio-injection=enabled --overwrite

echo Installing  postgres
helm -n $NS install postgres bitnami/postgresql --wait

echo Installing Istio gateway and vs
kubectl -n $NS apply -f istio/gateway.yaml
kubectl -n $NS apply -f istio/vs.yaml




