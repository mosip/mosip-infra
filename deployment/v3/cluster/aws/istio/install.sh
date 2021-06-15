#!/bin/sh
# Install ingress gateways
echo Operator init
istioctl operator init

echo Create ingress gateways and load balancers
kubectl apply -f iop.yaml

echo Wait for all resources to come up
sleep 10 
kubectl -n istio-system rollout status deploy istiod
kubectl -n istio-system rollout status deploy istio-ingressgateway
kubectl -n istio-system rollout status deploy istio-ingressgateway-internal

echo Installing gateways, proxy protocol, authpolicies
PUBLIC=`kubectl get cm global -o json | jq .data.\"mosip-api-host\"`
INTERNAL=`kubectl get cm global -o json | jq .data.\"mosip-api-internal-host\"`
echo Public domain: $PUBLIC
echo Internal dome: $INTERNAL
helm -n istio-system install istio-addons chart/istio-addons --set publicHost=$PUBLIC --set internalHost=$INTERNAL

echo ------ IMPORTANT ---------
echo If you already have pods running with envoy sidecars, restart all of them NOW.  Check if all of them appear with command "istioctl proxy-status"
echo --------------------------
