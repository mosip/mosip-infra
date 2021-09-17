#!/bin/sh
# Uninstalls Clamav
NS=clamav
while true; do
    read -p "Are you sure you want to delete Clamav helm chart?(Y/n) " yn
    if [ $yn == "Y" ]
      then
        helm -n $NS delete clamav
        break
      else
        break
    fi
done
