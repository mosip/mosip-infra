#!/bin/sh
# Installs all kernel helm charts 
NS=kernel

echo Create namespace
kubectl create ns $NS

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing authmanager
helm -n $NS install authmanager mosip/authmanager --wait

echo Installing auditmanager
helm -n $NS install auditmanager mosip/auditmanager --wait

echo Installing idgenerator
helm -n $NS install idgenerator mosip/idgenerator --wait 

echo Installing masterdata
helm -n $NS install masterdata mosip/masterdata --wait

echo Installing otpmanager
helm -n $NS install otpmanager mosip/otpmanager --wait

echo Installing pridgenerator
helm -n $NS install pridgenerator mosip/pridgenerator --wait

echo Installing ridgenerator
helm -n $NS install ridgenerator mosip/ridgenerator --wait

echo Installing syncdata
helm -n $NS install syncdata mosip/syncdata --wait
