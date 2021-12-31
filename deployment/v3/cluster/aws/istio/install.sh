#!/bin/sh
# Install ingress gateways
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

echo Operator init
istioctl operator init

echo Create ingress gateways and load balancers
kubectl apply -f iop.yaml

echo Wait for all resources to come up
sleep 30
kubectl -n istio-system rollout status deploy istiod
kubectl -n istio-system rollout status deploy istio-ingressgateway
kubectl -n istio-system rollout status deploy istio-ingressgateway-internal

echo Installing gateways, proxy protocol, authpolicies
PUBLIC=$(kubectl get cm global -o jsonpath={.data.mosip-api-host})
INTERNAL=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
echo Public domain: $PUBLIC
echo Internal domain: $INTERNAL
helm -n istio-system install istio-addons chart/istio-addons --set publicHost=$PUBLIC --set internalHost=$INTERNAL

echo ------ IMPORTANT ---------
echo If you already have pods running with envoy sidecars, restart all of them NOW.  Check if all of them appear with command "istioctl proxy-status"
echo --------------------------
