#!/bin/sh
# Uninstalls all PMS helm charts
NS=kernel
while true; do
    read -p "Are you sure you want to delete ALL PMS helm charts?(Y/n) " yn
    if [[ $yn == "Y" ]]
      then
        helm -n $NS delete pms-partner
        helm -n $NS delete pms-policy
        break
      else
        break
    fi
done
