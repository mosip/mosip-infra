#!/bin/sh
# Uninstalls Websub
NS=websub
while true; do
    read -p "Are you sure you want to delete Websub helm chart?(Y/n) " yn
    if [[ $yn == "Y" ]]
      then
        helm -n $NS delete websub
        break
      else
        break
    fi
done
