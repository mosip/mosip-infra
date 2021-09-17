#!/bin/sh
# Uninstalls Mock ABIS
NS=abis
while true; do
    read -p "Are you sure you want to delete Mock ABIS helm chart?(Y/n) " yn
    if [ $yn == "Y" ]
      then
        helm -n $NS delete mock-abis
        break
      else
        break
    fi
done
