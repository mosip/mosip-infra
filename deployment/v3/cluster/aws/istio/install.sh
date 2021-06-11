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

echo "Enable proxy protocol"
kubectl apply -f proxy-protocol.yaml

while true; do
  read -p "Have you set your domain host names in gateway.yaml and gateway-internal.yaml Y/n ?" yn
  if [[ $yn == "Y" ]]
    then
      echo "Install default gateways"
      kubectl apply -f gateway.yaml
      kubectl apply -f gateway-internal.yaml
      echo "apply auth policies"
      kubectl apply -f authpolicies/*
      break
    else
      break
  fi
done
echo ------ IMPORTANT ---------
echo If you already have pods running with envoy sidecars, restart all of them NOW.  Check if all of them appear with command "istioctl proxy-status"
echo --------------------------
