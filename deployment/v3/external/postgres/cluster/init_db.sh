#!/bin/sh
# Script to initialize the DB. 
NS=postgres
helm repo update
while true; do
    read -p "CAUTION: all existing data will be lost. Are you sure ? Y/n ?" yn
    if [[ $yn == "Y" ]]
      then
        echo Removing any existing installation
        helm -n $NS delete postgres-init
        helm -n $NS install postgres-init mosip/postgres-init -f init_values.yaml --wait --wait-for-jobs
        break
      else
        break
    fi
done
