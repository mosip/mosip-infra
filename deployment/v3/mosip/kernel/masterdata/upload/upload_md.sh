#!/bin/sh
# Usage: ./upload_md.sh [kubeconfig file] 
# Default kubeconfig file is $HOME/.kube/config
# Run in virtual env
if [ $# -ge 1 ]
  then
    export KUBECONFIG=$1
fi
read -p "Enter IAM username: " iam_user

# This username is hardcoded in sql scripts
DB_PWD=$(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
DB_HOST=`kubectl get cm global -o json | jq .data.\"mosip-api-internal-host\" | tr -d '"'`
DB_PORT=5432
XLS=xlsx

while true; do
    read -p "WARNING: All existing masterdata will be erased. Are you sure?(Y/n) " yn
    if [ $yn == "Y" ]
      then
        echo Uploading ..
        cd lib
        python upload_masterdata.py $DB_HOST $DB_PWD $iam_user ../$XLS
        break
      else
        break
    fi
done

