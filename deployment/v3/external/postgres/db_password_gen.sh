#!/bin/bash
# Script to initialize the DB-PASSWORD.
## Usage: ./db_password_gen.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=db-password
kubectl create ns $NS
CHART_VERSION=12.0.2
helm repo update
while true; do
    read -p "CAUTION: db-passwords will be recreated. Are you sure to regenerate?(Y/n)" yn
    if [ $yn = "Y" ]
      then
        echo Removing any existing installation
        helm -n $NS delete db-password-gen
        echo Initializing DB-PASSWORD
        helm -n $NS install db-password-gen mosip/db-password-gen -f init_values.yaml --version $CHART_VERSION
        break
      else
        break
    fi
done