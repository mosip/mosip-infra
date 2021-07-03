#!/bin/sh
# Install ingress gateway
echo Operator init
istioctl operator init

echo Create ingress gateways and load balancers
kubectl apply -f iop.yaml

echo Wait for all resources to come up
sleep 10 
kubectl -n istio-system rollout status deploy istiod
kubectl -n istio-system rollout status deploy istio-ingressgateway

echo Installing gateways, proxy protocol
HOST=rancher.xyz.net
helm -n istio-system install istio-addons chart/istio-addons --set host=HOST

echo ------ IMPORTANT ---------
echo If you already have pods running with envoy sidecars, restart all of them NOW.  Check if all of them appear with command "istioctl proxy-status"
echo --------------------------
