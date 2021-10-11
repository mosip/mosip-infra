#!/bin/sh
# Get fluentd.conf  and fluent.conf
## Usage: ./get_conf.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi
echo fluentd.conf: $(kubectl get secret --namespace cattle-logging-system rancher-logging-eks-fluentd-app -o jsonpath="{.data.fluentd\.conf}" | base64 --decode)
echo ''
echo fluent.conf: $(kubectl get secret --namespace cattle-logging-system rancher-logging-eks-fluentd -o jsonpath="{.data.fluent\.conf}" | base64 --decode)
