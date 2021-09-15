#!/bin/bash
# Uninstalls Print service
NS=print
while true; do
    read -p "Are you sure you want to delete Print helm chart?(Y/n) " yn
    if [[ $yn == "Y" ]]
      then
        helm -n $NS delete print-service
        break
      else
        break
    fi
done
