#!/bin/sh
# Installs the mosip-compliance-toolkit-ui module
# Make sure you have updated ui_values.yaml
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=admin
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

API_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
mosip-compliance-toolkit-ui_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-mosip-compliance-toolkit-ui-host})

echo Installing mosip-compliance-toolkit-ui-Proxy into Masterdata and Keymanager.
kubectl -n $NS apply -f mosip-compliance-toolkit-ui-proxy.yaml

echo Installing mosip-compliance-toolkit-ui
helm -n $NS install mosip-compliance-toolkit-ui mosip/mosip-compliance-toolkit-ui --set mosip-compliance-toolkit-ui.apiUrl=https://$API_HOST/v1/ --set istio.hosts\[0\]=$mosip-compliance-toolkit-ui_HOST --version $CHART_VERSION

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Installed mosip-compliance-toolkit-ui

echo "mosip-compliance-toolkit-ui portal URL: https://$mosip-compliance-toolkit-ui_HOST/mosip-compliance-toolkit-ui"