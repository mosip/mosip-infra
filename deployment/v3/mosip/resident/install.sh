#!/bin/sh
# Installs resident service
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=resident
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

API_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
resident_ui_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-resident-ui-host})


#echo Installing Resident
helm -n $NS install resident mosip/resident --set istio.corsPolicy.allowOrigins.\[0\].prefix=$resident_ui_HOST --version $CHART_VERSION

#echo Installing resident-ui-Proxy into Masterdata and Keymanager.
#kubectl -n $NS apply -f resident-ui-proxy.yaml

echo Installing resident-ui
helm -n $NS install resident-ui ~/IdeaProjects/new/mosip-helm/charts/resident-ui --set residentUi.apiHost=$API_HOST --set istio.hosts\[0\]=$resident_ui_HOST --version $CHART_VERSION

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

#echo Intalled resident services

echo Installed resident-ui

echo "resident-ui portal URL: https://$resident_ui_HOST/resident-ui"