#!/bin/sh
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=httpbin
kubectl create ns $NS 
kubectl label ns $NS istio-injection=enabled --overwrite

kubectl -n $NS apply -f svc.yaml
kubectl -n $NS apply -f deployment.yaml 
kubectl -n $NS apply -f vs.yaml
