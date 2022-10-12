#!/bin/sh
# Uninstalls config server
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=config-server
while true; do
    read -p "Are you sure you want to delete config-server helm charts?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        kubectl -n $NS delete configmap global keycloak-host activemq-activemq-artemis-share s3 email-gateway
        kubectl -n $NS delete secret db-mosip-audit-secret db-mosip-authdevice-secret db-mosip-credential-secret db-mosip-digitalcard-secret db-mosip-hotlist-secret db-mosip-ida-secret db-mosip-idmap-secret db-mosip-idp-secret db-mosip-idrepo-secret db-mosip-kernel-secret db-mosip-keymgr-secret db-mosip-master-secret db-mosip-pms-secret db-mosip-prereg-secret db-mosip-regdevice-secret db-mosip-regprc-secret db-mosip-resident-secret db-mosip-toolkit-secret keycloak keycloak-client-secrets activemq-activemq-artemis softhsm-kernel softhsm-ida s3 email-gateway prereg-captcha
        helm -n $NS delete config-server
        break
      else
        break
    fi
done
