#!/bin/bash
# Uninstalls config server
NS=config-server
while true; do
    read -p "Are you sure you want to delete config-server helm charts?(Y/n) " yn
    if [[ $yn == "Y" ]]
      then
        helm -n $NS delete config-server
        break
      else
        break
    fi
done
