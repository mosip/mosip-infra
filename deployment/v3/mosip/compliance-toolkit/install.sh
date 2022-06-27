#!/bin/sh
# Installs all compliance-toolkit helm charts
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
COMPLIANCE_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-compliance-host})

echo Installing compliance-toolkit
helm -n $NS install compliance-toolkit mosip/compliance-toolkit --set istio.corsPolicy.allowOrigins\[0\].prefix=$COMPLIANCE_HOST --version $CHART_VERSION

echo Installing compliance-toolkit-ui
helm -n $NS install compliance-toolkit-ui mosip/compliance-toolkit-ui --set compliance_toolkit_ui.apiHost=$API_HOST --set istio.hosts\[0\]=$COMPLIANCE_HOST --version $CHART_VERSION

echo Installed compliance-toolkit and compliance-toolkit-ui

echo "compliance-toolkit-ui portal URL: https://$COMPLIANCE_HOST/"

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Installed compliance-toolkit services
