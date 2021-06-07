#!/bin/sh
# Uninstalls all Admin helm charts 
NS=admin
while true; do
    read -p "Are you sure you want to delete ALL Admin helm charts? Y/n ?" yn
    if [[ $yn == "Y" ]]
      then
        helm -n $NS delete admin-ui
        helm -n $NS delete admin-service
        break
      else
        break
    fi
done
