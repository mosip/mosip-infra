#!/bin/bash
# Uninstalls kafka
NS=kafka
while true; do
    read -p "Are you sure you want to delete kafka helm chart? Y/n ?" yn
    if [[ $yn == "Y" ]]
      then
        helm -n $NS delete kafka
        break
      else
        break
    fi
done
