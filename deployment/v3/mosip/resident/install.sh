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

echo Installing Resident
helm -n $NS install resident mosip/resident --version $CHART_VERSION

API_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
resident-ui_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-resident-ui-host})

#echo Installing resident-ui-Proxy into Masterdata and Keymanager.
#kubectl -n $NS apply -f resident-ui-proxy.yaml

echo Installing resident-ui
helm -n $NS install resident-ui mosip/resident-ui --set resident-ui.apiUrl=https://$API_HOST/v1/ --set istio.hosts\[0\]=$resident-ui_HOST --version $CHART_VERSION

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Intalled resident services

echo Installed resident-ui

echo "resident-ui portal URL: https://$resident-ui_HOST/resident-ui"
