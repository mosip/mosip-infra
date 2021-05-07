#!/bin/sh
ISTIO_BASE=./istio-1.9.4
kubectl create namespace istio-system
helm -n istio-system install istio-base $ISTIO_BASE/manifests/charts/base
helm -n istio-system install istiod $ISTIO_BASE/manifests/charts/istio-control/istio-discovery 
helm -n istio-system install istio-ingress $ISTIO_BASE/manifests/charts/gateways/istio-ingress -f override.yaml --wait
kubectl apply -f proxy-protocol.yaml
kubectl apply -f fowarded.yaml

