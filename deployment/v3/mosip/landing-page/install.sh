#!/bin/sh
# Installs resident service
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=landing-page
CHART_VERSION=12.0.1-B2

echo Create $NS namespace
kubectl create ns $NS

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

VERSION=`git branch | grep "\*" | cut -d ' ' -f 2`
NAME=$(kubectl get cm global -o jsonpath={.data.installation-name})
DOMAIN=$(kubectl get cm global -o jsonpath={.data.installation-domain})
API=$(kubectl get cm global -o jsonpath={.data.mosip-api-host})
API_INTERNAL=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
ADMIN=$(kubectl get cm global -o jsonpath={.data.mosip-admin-host})
PREREG=$(kubectl get cm global -o jsonpath={.data.mosip-prereg-host})
KAFKA=$(kubectl get cm global -o jsonpath={.data.mosip-kafka-host})
KIBANA=$(kubectl get cm global -o jsonpath={.data.mosip-kibana-host})
ACTIVEMQ=$(kubectl get cm global -o jsonpath={.data.mosip-activemq-host})
MINIO=$(kubectl get cm global -o jsonpath={.data.mosip-minio-host})
KEYCLOAK=$(kubectl get cm global -o jsonpath={.data.mosip-iam-external-host})
REGCLIENT=$(kubectl get cm global -o jsonpath={.data.mosip-regclient-host})
POSTGRES=$(kubectl get cm global -o jsonpath={.data.mosip-postgres-host})
POSTGRES_PORT=5432  
PMP=$(kubectl get cm global -o jsonpath={.data.mosip-pmp-host})

echo Installing landing page
helm -n $NS install landing-page mosip/landing-page --version $CHART_VERSION  \
--set landing.version=$VERSION \
--set landing.name=$NAME \
--set landing.api=$API \
--set landing.apiInternal=$API_INTERNAL \
--set landing.admin=$ADMIN  \
--set landing.prereg=$PREREG  \
--set landing.kafka=$KAFKA \
--set landing.kibana=$KIBANA \
--set landing.activemq=$ACTIVEMQ  \
--set landing.minio=$MINIO \
--set landing.keycloak=$KEYCLOAK  \
--set landing.regclient=$REGCLIENT  \
--set landing.postgres.host=$POSTGRES \
--set landing.postgres.port=$POSTGRES_PORT \
--set landing.pmp=$PMP \
--set istio.host=$DOMAIN

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Installed landing page
