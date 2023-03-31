#!/bin/bash
# Installs resident service
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=landing-page
CHART_VERSION=12.0.1-B3

echo Create $NS namespace
kubectl create ns $NS

function landing_page() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
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
  COMPLIANCE=$(kubectl get cm global -o jsonpath={.data.mosip-compliance-host})
  RESIDENT=$(kubectl get cm global -o jsonpath={.data.mosip-resident-host})
  ESIGNET=$(kubectl get cm global -o jsonpath={.data.mosip-esignet-host})
  SMTP=$(kubectl get cm global -o jsonpath={.data.mosip-smtp-host})

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
  --set landing.compliance=$COMPLIANCE \
  --set landing.resident=$RESIDENT \
  --set landing.esignet=$ESIGNET \
  --set landing.smtp=$SMTP \
  --set istio.host=$DOMAIN

  kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status
  echo Installed landing page
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
landing_page   # calling function
