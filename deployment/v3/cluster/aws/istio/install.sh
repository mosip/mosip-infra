#!/bin/sh
# Install ingress gateways

echo "Create namespace istio-system"
kubectl create namespace istio-system
echo "Operator init"
istioctl operator init
echo "Create ingress gateways and load balancers"
kubectl apply -f iop.yaml
echo "Enable proxy protocol"
kubectl apply -f proxy-protocol.yaml
kubectl apply -f forwarded.yaml
echo "Install default gateways"
while true; do
  read -p "Have you set your domain host names in gateway.yaml and gateway-internal.yaml Y/n ?" yn
  if [[ $yn == "Y" ]]
    then
      kubectl apply -f gateway.yaml
      kubectl apply -f gateway-internal.yaml
      break
    else
      break
  fi
done
echo "apply auth policies"
kubectl apply -f authpolicies/*
