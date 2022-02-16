#!/bin/sh
# Uninstalls Websub
NS=websub
while true; do
    read -p "Are you sure you want to delete Websub helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete websub
        helm -n $NS delete websub-consolidator
        break
      else
        break
    fi
done
