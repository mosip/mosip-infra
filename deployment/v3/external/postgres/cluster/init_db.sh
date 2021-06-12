#!/bin/sh
# Script to initialize the DB. 
NS=postgres
helm repo update mosip
while true; do
    read -p "CAUTION: all existing data will be lost. Are you sure ? Y/n ?" yn
    if [[ $yn == "Y" ]]
      then
        helm -n postgres install postgres-init mosip/postgres-init -f init_values.yaml
        break
      else
        break
    fi
done
