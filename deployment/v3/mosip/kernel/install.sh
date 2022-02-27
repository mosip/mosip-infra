#!/bin/sh
# Installs all kernel helm charts 
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=kernel
CHART_VERSION=1.1.5

echo Create namespace
kubectl create ns $NS

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing authmanager
helm -n $NS install authmanager -f auth-values.yaml mosip/authmanager --version $CHART_VERSION

echo Installing auditmanager
helm -n $NS install auditmanager mosip/auditmanager -f audit-values.yaml --version $CHART_VERSION

echo Installing idgenerator
helm -n $NS install idgenerator mosip/idgenerator -f idgen-values.yaml --version $CHART_VERSION

echo Installing masterdata
helm -n $NS install masterdata mosip/masterdata -f master-values.yaml --version $CHART_VERSION

echo Installing otpmanager
helm -n $NS install otpmanager mosip/otpmanager -f otp-values.yaml --version $CHART_VERSION

echo Installing pridgenerator
helm -n $NS install pridgenerator mosip/pridgenerator -f prid-values.yaml --version $CHART_VERSION

echo Installing ridgenerator
helm -n $NS install ridgenerator mosip/ridgenerator -f rid-values.yaml --version $CHART_VERSION

echo Installing syncdata
helm -n $NS install syncdata mosip/syncdata -f sync-values.yaml --version $CHART_VERSION

echo Installing notifier
helm -n $NS install notifier mosip/notifier -f notifier-values.yaml --version $CHART_VERSION
