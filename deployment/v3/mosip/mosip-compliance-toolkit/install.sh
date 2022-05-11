#!/bin/sh
# Installs all mosip-compliance-toolkit helm charts
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=prereg
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=disabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

API_HOST=`kubectl get cm global -o jsonpath={.data.mosip-api-host}`
mosip-compliance-toolkit_HOST=`kubectl get cm global -o jsonpath={.data.mosip-prereg-host}`

echo Install mosip-compliance-toolkit-gateway
helm -n $NS install mosip-compliance-toolkit-gateway mosip/mosip-compliance-toolkit-gateway --set istio.hosts[0]=$mosip-compliance-toolkit --version $CHART_VERSION

echo Installing mosip-compliance-toolkit
helm -n $NS install mosip-compliance-toolkit mosip/mosip-compliance-toolkit --version $CHART_VERSION



kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Installed mosip-compliance-toolkit services