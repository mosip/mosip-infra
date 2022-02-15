#!/bin/sh
# Uninstalls datashare
NS=datashare
while true; do
    read -p "Are you sure you want to delete Datashare helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete datashare
        break
      else
        break
    fi
done
