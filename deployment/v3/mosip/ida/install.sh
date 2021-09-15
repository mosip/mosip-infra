#!/bin/bash
# Installs all kernel helm charts 
NS=ida
CHART_VERSION=1.2.0

echo Create namespace
kubectl create ns $NS

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Running ida keygen
helm -n $NS install ida-keygen mosip/ida-keygen --version $CHART_VERSION

echo Installing ida auth 
helm -n $NS install ida-auth mosip/ida-auth --version $CHART_VERSION

echo Installing ida internal
helm -n $NS install ida-internal mosip/ida-internal --version $CHART_VERSION

echo Installing ida kyc
helm -n $NS install ida-kyc mosip/ida-kyc --version $CHART_VERSION

echo Installing ida otp
helm -n $NS install ida-otp mosip/ida-otp --version $CHART_VERSION

