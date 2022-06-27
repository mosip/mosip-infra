#!/bin/sh
# Uninstalls all  compliance-toolkit helm charts
NS=compliance-toolkit
while true; do
    read -p "Are you sure you want to delete all compliance-toolkit helm charts?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete compliance-toolkit
        helm -n $NS delete compliance-toolkit-ui
        break
      else
        break
    fi
done
