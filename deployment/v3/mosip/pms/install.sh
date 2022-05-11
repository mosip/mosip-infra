#!/bin/sh
# Installs all PMS charts
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=pms
CHART_VERSION=12.0.1

API_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
PMP_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-pmp-host})

echo Create $NS namespace
kubectl create ns $NS

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

INTERNAL_API_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
PMP_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-pmp-host})

echo Installing partner manager
helm -n $NS install pms-partner mosip/pms-partner --set istio.corsPolicy.allowOrigins\[0\].prefix=https://$PMP_HOST --version $CHART_VERSION

echo Installing policy manager
helm -n $NS install pms-policy mosip/pms-policy --set istio.corsPolicy.allowOrigins\[0\].prefix=https://$PMP_HOST --version $CHART_VERSION

echo Installing pmp-ui
helm -n pms install pmp-ui mosip/pmp-ui  --set pmp.apiUrl=https://$INTERNAL_API_HOST/ --set istio.hosts=["$PMP_HOST"] --version $CHART_VERSION

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Intalled pms services

echo "Admin portal URL: https://$PMP_HOST/pmp-ui/"
