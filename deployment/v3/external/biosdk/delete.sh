#!/bin/sh
# Uninstalls Biosdk
NS=biosdk
while true; do
    read -p "Are you sure you want to delete Biosdk Service helm chart?(Y/n) " yn
    if [[ $yn == "Y" ]]
      then
        helm -n $NS delete biosdk-service
        break
      else
        break
    fi
done
