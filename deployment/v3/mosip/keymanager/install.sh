#!/bin/sh
# Installs Keymanager
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=keymanager
CHART_VERSION=1.2.0

echo Istio label
kubectl label ns $NS istio-injection=enabled --overwrite
kubectl apply -n $NS -f idle_timeout_envoyfilter.yaml
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Running keygenerator. This may take a few minutes..
helm -n $NS install kernel-keygen mosip/kernel-keygen --wait --wait-for-jobs --version $CHART_VERSION

echo Installing keymanager
helm -n $NS install keymanager mosip/keymanager --version $CHART_VERSION
