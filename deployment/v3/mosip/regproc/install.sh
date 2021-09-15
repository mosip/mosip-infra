#!/bin/bash
# Installs all Regproc helm charts
NS=regproc
CHART_VERSION=1.1.5

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing regproc-status
helm -n $NS install regproc-status mosip/regproc-status --version $CHART_VERSION

echo Installing regproc-camel
helm -n $NS install regproc-camel mosip/regproc-camel --version $CHART_VERSION

echo Installing regproc-receiver
helm -n $NS install regproc-receiver mosip/regproc-receiver -f receiver_values.yaml --version $CHART_VERSION

echo Installing regproc-pktserver
helm -n $NS install regproc-pktserver mosip/regproc-pktserver --version $CHART_VERSION

echo Installing regproc-uploader
helm -n $NS install regproc-uploader mosip/regproc-uploader --version $CHART_VERSION

echo Installing regproc-uploader
helm -n $NS install regproc-validator mosip/regproc-validator --version $CHART_VERSION

echo Installing regproc-quality
helm -n $NS install regproc-quality mosip/regproc-quality --version $CHART_VERSION

echo Installing regproc-osi
helm -n $NS install regproc-osi mosip/regproc-osi --version $CHART_VERSION

echo Installing regproc-demo
helm -n $NS install regproc-demo mosip/regproc-demo --version $CHART_VERSION

echo Installing regproc-biodedupe
helm -n $NS install regproc-biodedupe mosip/regproc-biodedupe --version $CHART_VERSION

echo Installing regproc-abishandler
helm -n $NS install regproc-abishandler mosip/regproc-abishandler --version $CHART_VERSION

echo Installing regproc-abismid
helm -n $NS install regproc-abismid mosip/regproc-abismid --version $CHART_VERSION

echo Installing regproc-manual
helm -n $NS install regproc-manual mosip/regproc-manual --version $CHART_VERSION

echo Installing regproc-bioauth
helm -n $NS install regproc-bioauth mosip/regproc-bioauth --version $CHART_VERSION

echo Installing regproc-eis
helm -n $NS install regproc-eis mosip/regproc-eis --version $CHART_VERSION

echo Installing regproc-external
helm -n $NS install regproc-external mosip/regproc-external --version $CHART_VERSION

echo Installing regproc-msg
helm -n $NS install regproc-msg mosip/regproc-msg --version $CHART_VERSION

echo Installing regproc-print
helm -n $NS install regproc-print mosip/regproc-print --version $CHART_VERSION

echo Installing regproc-reprocess
helm -n $NS install regproc-reprocess mosip/regproc-reprocess --version $CHART_VERSION

echo Installing regproc-trans
helm -n $NS install regproc-trans mosip/regproc-trans --version $CHART_VERSION

echo Installing regproc-uin
helm -n $NS install regproc-uin mosip/regproc-uin --version $CHART_VERSION

