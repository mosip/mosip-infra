#!/bin/sh
# Uninstalls all postgres resources
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=postgres
while true; do
    read -p "CAUTION: PVC, PV will get deleted. If your PV is not in 'Retain' mode all data will be lost. Are you sure ? Y/n ?" yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete postgres
        helm -n $NS delete istio-addons
        kubectl -n $NS delete pvc -l app.kubernetes.io/name=postgresql
        break
      else
        break
    fi
done
