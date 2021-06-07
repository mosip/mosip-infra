#!/bin/sh
# Installs all Regproc helm charts
NS=regproc

echo Copy configmaps
./copy_cm.sh

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing regproc-status
helm -n regproc install regproc-status mosip/regproc-status

echo Installing regproc-camel
helm -n regproc install regproc-camel mosip/regproc-camel

echo Installing regproc-receiver
helm -n regproc install regproc-receiver mosip/regproc-receiver

echo Installing regproc-pktserver
helm -n regproc install regproc-pktserver mosip/regproc-pktserver

echo Installing regproc-uploader
helm -n regproc install regproc-uploader mosip/regproc-uploader

echo Installing regproc-uploader
helm -n regproc install regproc-validator mosip/regproc-validator

echo Installing regproc-quality
helm -n regproc install regproc-quality mosip/regproc-quality

echo Installing regproc-osi
helm -n regproc install regproc-osi mosip/regproc-osi

echo Installing regproc-demo
helm -n regproc install regproc-demo mosip/regproc-demo

echo Installing regproc-biodupe
helm -n regproc install regproc-biodupe mosip/regproc-biodupe

echo Installing regproc-abishandler
helm -n regproc install regproc-abishandler mosip/regproc-abishandler

echo Installing regproc-abismid
helm -n regproc install regproc-abismid mosip/regproc-abismid

echo Installing regproc-manual
helm -n regproc install regproc-manual mosip/regproc-manual

echo Installing regproc-bioauth
helm -n regproc install regproc-bioauth mosip/regproc-bioauth

echo Installing regproc-eis
helm -n regproc install regproc-eis mosip/regproc-eis

echo Installing regproc-external
helm -n regproc install regproc-external mosip/regproc-external

echo Installing regproc-msg
helm -n regproc install regproc-msg mosip/regproc-msg

echo Installing regproc-print
helm -n regproc install regproc-print mosip/regproc-print

echo Installing regproc-reprocess
helm -n regproc install regproc-reprocess mosip/regproc-reprocess

echo Installing regproc-trans
helm -n regproc install regproc-trans mosip/regproc-trans

echo Installing regproc-uin
helm -n regproc install regproc-uin mosip/regproc-uin

