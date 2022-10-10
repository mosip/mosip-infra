#!/bin/sh
# Installs Softhsm for Kernel and IDA
## Usage: ./install.sh [kubeconfig]


if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=softhsm
CHART_VERSION=12.0.2

echo Create $NS namespaces
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing Softhsm for Kernel
helm -n $NS install softhsm-kernel mosip/softhsm -f values.yaml --version $CHART_VERSION --wait
echo Installed Softhsm for Kernel

echo Installing Softhsm for IDA
helm -n $NS install softhsm-ida mosip/softhsm -f values.yaml --version $CHART_VERSION --wait
echo Installed Softhsm for IDA

echo Installing Softhsm for IDP
helm -n $NS install softhsm-idp mosip/softhsm -f values.yaml --version $CHART_VERSION --wait
echo Installed Softhsm for IDP
