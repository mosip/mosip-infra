#!/bin/sh
# Installs all ida helm charts 
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=ida
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Running ida keygen
helm -n $NS install ida-keygen mosip/keygen --wait --wait-for-jobs  --version $CHART_VERSION -f keygen_values.yaml

echo Installing ida auth 
helm -n $NS install ida-auth mosip/ida-auth --version $CHART_VERSION

echo Installing ida internal
helm -n $NS install ida-internal mosip/ida-internal --version $CHART_VERSION

echo Installing ida otp
helm -n $NS install ida-otp mosip/ida-otp --version $CHART_VERSION

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Intalled ida services
