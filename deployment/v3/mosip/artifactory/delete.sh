#!/bin/sh
# Uninstalls artifactory
NS=artifactory
while true; do
    read -p "Are you sure you want to delete artifactory helm chart?(Y/n) " yn
    if [[ $yn == "Y" ]]
      then
        helm -n $NS delete artifactory
        break
      else
        break
    fi
done
