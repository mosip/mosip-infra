#!/bin/sh
# Installs all kernel helm charts 
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
helm -n $NS install authmanager mosip/authmanager --version $CHART_VERSION

echo Installing auditmanager
helm -n $NS install auditmanager mosip/auditmanager --version $CHART_VERSION

echo Installing idgenerator
helm -n $NS install idgenerator mosip/idgenerator --version $CHART_VERSION

echo Installing masterdata
helm -n $NS install masterdata mosip/masterdata --version $CHART_VERSION

echo Installing otpmanager
helm -n $NS install otpmanager mosip/otpmanager --version $CHART_VERSION

echo Installing pridgenerator
helm -n $NS install pridgenerator mosip/pridgenerator --version $CHART_VERSION

echo Installing ridgenerator
helm -n $NS install ridgenerator mosip/ridgenerator --version $CHART_VERSION

echo Installing syncdata
helm -n $NS install syncdata mosip/syncdata --version $CHART_VERSION

echo Installing notifier
helm -n $NS install notifier mosip/notifier --version $CHART_VERSION
