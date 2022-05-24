#!/bin/sh
# Uninstalls resident 
NS=resident
while true; do
    read -p "Are you sure you want to delete resident helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete resident
        helm -n $NS delete resident-app
        helm -n $NS delete resident-ui
#        kubectl delete -n $NS -f resident-ui
        break
      else
        break
    fi
done
