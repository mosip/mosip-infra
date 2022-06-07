#!/bin/bash

NS=oauth2-proxy

if [ $# -ge 1 ]; then
  export KUBECONFIG=$1
fi

kubectl delete -n $NS -f oauth2-proxy.yaml
