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
        kubectl -n $NS delete secret keycloak keycloak-client-secrets activemq-activemq-artemis softhsm-kernel softhsm-ida s3 email-gateway prereg-captcha
        DB_SECRET_REGEX='db-.*-secret'
        db_secrets_list=$(kubectl get secrets -n $NS --no-headers -o custom-columns=':.metadata.name' | grep "$DB_SECRET_REGEX")
        for db_secret in $db_secrets_list; do
          kubectl -n $NS delete secret $db_secret
        done
        helm -n $NS delete config-server
        break
      else
        break
    fi
done
