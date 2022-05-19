#!/bin/sh
# Installs all mosip-compliance-toolkit helm charts
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=compliance-toolkit
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=disabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

API_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
mosip-compliance-toolkit-ui_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-mosip-compliance-toolkit-ui-host})

echo Installing compliance-toolkit
helm -n $NS install compliance-toolkit mosip/mosip-compliance-toolkit --version $CHART_VERSION

echo Installing compliance-toolkit-ui
helm -n $NS install compliance-toolkit-ui mosip/mosip-compliance-toolkit-ui --set mosip-compliance-toolkit-ui.apiUrl=https://$API_HOST/v1/ --set istio.hosts\[0\]=$mosip-compliance-toolkit-ui_HOST --version $CHART_VERSION

echo Installed compliance-toolkit and compliance-toolkit-ui

echo "compliance-toolkit-ui portal URL: https://$mosip-compliance-toolkit-ui_HOST/mosip-compliance-toolkit-ui"

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Installed mosip-compliance-toolkit services
