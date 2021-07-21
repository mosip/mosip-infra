#!/bin/sh
# Installs all Regproc helm charts
NS=regproc

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing regproc-status
helm -n $NS install regproc-status mosip/regproc-status

echo Installing regproc-camel
helm -n $NS install regproc-camel mosip/regproc-camel

echo Installing regproc-receiver
helm -n $NS install regproc-receiver mosip/regproc-receiver -f receiver_values.yaml

echo Installing regproc-pktserver
helm -n $NS install regproc-pktserver mosip/regproc-pktserver

echo Installing regproc-uploader
helm -n $NS install regproc-uploader mosip/regproc-uploader

echo Installing regproc-uploader
helm -n $NS install regproc-validator mosip/regproc-validator

echo Installing regproc-quality
helm -n $NS install regproc-quality mosip/regproc-quality

echo Installing regproc-osi
helm -n $NS install regproc-osi mosip/regproc-osi

echo Installing regproc-demo
helm -n $NS install regproc-demo mosip/regproc-demo

echo Installing regproc-biodupe
helm -n $NS install regproc-biodupe mosip/regproc-biodupe

echo Installing regproc-abishandler
helm -n $NS install regproc-abishandler mosip/regproc-abishandler

echo Installing regproc-abismid
helm -n $NS install regproc-abismid mosip/regproc-abismid

echo Installing regproc-manual
helm -n $NS install regproc-manual mosip/regproc-manual

echo Installing regproc-bioauth
helm -n $NS install regproc-bioauth mosip/regproc-bioauth

echo Installing regproc-eis
helm -n $NS install regproc-eis mosip/regproc-eis

echo Installing regproc-external
helm -n $NS install regproc-external mosip/regproc-external

echo Installing regproc-msg
helm -n $NS install regproc-msg mosip/regproc-msg

echo Installing regproc-print
helm -n $NS install regproc-print mosip/regproc-print

echo Installing regproc-reprocess
helm -n $NS install regproc-reprocess mosip/regproc-reprocess

echo Installing regproc-trans
helm -n $NS install regproc-trans mosip/regproc-trans

echo Installing regproc-uin
helm -n $NS install regproc-uin mosip/regproc-uin

