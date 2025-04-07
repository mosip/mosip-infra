#!/bin/bash

NS=landing-page

function landing_page_setup() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite

  kubectl get configmap global -n default -o yaml \
  | sed 's/namespace: default/namespace: landing-page/' \
  | kubectl apply -f -

  VERSION=$(kubectl get cm global -o jsonpath={.data.mosip-version})
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
  HEALTHSERVICES=$(kubectl get cm global -o jsonpath={.data.mosip-healthservices-host})
  INJIWEB=$(kubectl get cm global -o jsonpath={.data.mosip-injiweb-host})
  INJIVERIFY=$(kubectl get cm global -o jsonpath={.data.mosip-injiverify-host})

  return 0
}
# Set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialized variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
landing_page_setup   # calling function
