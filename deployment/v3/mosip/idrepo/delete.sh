#!/bin/sh
# Uninstalls idrepo services
NS=idrepo
while true; do
    read -p "Are you sure you want to delete Idrepo helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete idrepo-saltgen
        helm -n $NS delete credential
        helm -n $NS delete credentialrequest
        helm -n $NS delete identity
        helm -n $NS delete vid
        break
      else
        break
    fi
done
