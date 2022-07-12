#!/bin/sh
# Uninstalls partner-onboarder helm
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi
NS=onboarder
echo Deleting partner-onboarder helm
kubectl -n $NS delete configmap global
helm -n $NS delete partner-onboarder
