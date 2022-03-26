#!/bin/sh
# Installs the admin module
# Make sure you have updated ui_values.yaml
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=admin
CHART_VERSION=12.0.1

echo Create $NS namespace
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

API_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
ADMIN_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-admin-host})

echo Installing admin hotlist service.
helm -n $NS install admin-hotlist mosip/admin-hotlist --version $CHART_VERSION

echo Installing admin service. Will wait till service gets installed.
helm -n $NS install admin-service mosip/admin-service --set istio.corsPolicy.allowOrigins\[0\].prefix=https://$ADMIN_HOST --wait --version $CHART_VERSION

echo Installing admin-ui
helm -n $NS install admin-ui mosip/admin-ui --set admin.apiUrl=https://$API_HOST/v1/ --set istio.hosts\[0\]=$ADMIN_HOST --version $CHART_VERSION

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Installed admin services

echo "Admin portal URL: https://$ADMIN_HOST/admin-ui/"
