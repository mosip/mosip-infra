#!/bin/sh
## Removes all the Istio resources along with Load Balancers.

## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=istio-system
NS1=istio-operator

echo Removing Istio components
istioctl x uninstall --purge

echo deleting $NS and $NS1 namespaces

kubectl delete ns $NS $NS1
