#!/bin/sh

if [ $# -ge 2 ] ; then
  export KUBECONFIG=$2
fi

CLIENT_POD_NAME=kafka-client
NS=reporting
API_CALL=$(cat $1)

kubectl exec -it $CLIENT_POD_NAME -n $NS -- sh -xc "$API_CALL"
