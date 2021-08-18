#!/bin/sh
# Install ingress gateway
KC="--kubeconfig $HOME/.kube/iam_config"

echo Operator init
istioctl $KC  operator init

echo Create ingress gateways and load balancers
kubectl $KC apply -f iop.yaml

echo Wait for all resources to come up
sleep 20 
kubectl $KC -n istio-system rollout status deploy istiod
kubectl $KC -n istio-system rollout status deploy istio-ingressgateway

echo Installing gateways, proxy protocol
HOST=rancher.xyz.net
kubectl $KC create ns cattle-system
helm $KC -n cattle-system install istio-addons chart/istio-addons --set host=$HOST

echo ------ IMPORTANT ---------
echo If you already have pods running with envoy sidecars, restart all of them NOW.  Check if all of them appear with command "istioctl proxy-status"
echo --------------------------
