#!/usr/bin/env bash
# Shell script to restart all modules

# colores
blanc="\033[1;37m"
gray="\033[0;37m"
magento="\033[0;35m"
red="\033[1;31m"
green="\033[1;32m"
amarillo="\033[1;33m"
azul="\033[1;34m"
rescolor="\e[0m"
REPO_FILE=./modules.txt

while IFS="=" read -r key value; do
  SERVICE_NAME=$value
  NAMESPACE=$key
  kubectl --kubeconfig /home/mosipuser/.kube/mzcluster.config get pods -n ${NAMESPACE} | awk '/'${SERVICE_NAME}'/{print $1}'| xargs  kubectl --kubeconfig /home/mosipuser/.kube/mzcluster.config -n ${NAMESPACE} delete pod
    listPods=$(kubectl --kubeconfig /home/mosipuser/.kube/mzcluster.config get pods -n ${NAMESPACE} | awk '/'${SERVICE_NAME}'/{print $1}')
    readarray  arr <<<  $listPods
    ok=0
    notok=0
    echo -e "\nSit Down and Wait  \U1F602 :\n"
    sleep 5m
    for i in ${arr[@]}
    do
    echo -ne "$i ... "
    status=$(kubectl --kubeconfig /home/mosipuser/.kube/mzcluster.config get pod $i -n ${NAMESPACE} | grep $i | awk '{print $3}')
            if [[ ! $status =~ ^Running$|^Completed$  ]]  ; then
              echo -e "\e[1;31mPod is Not UP"$rescolor""
              let notok=notok+1
            else
               if [[ $(kubectl --kubeconfig /home/mosipuser/.kube/mzcluster.config get pod $i -n ${NAMESPACE} -o jsonpath='{.status.containerStatuses[*].ready}') == 'true'  ]]
               then
                 echo -e "\e[1;32mPod is up !"$rescolor""
               else
                 echo -e "\e[1;31mPod is either in Crash loop or Health Check failing"$rescolor""
               fi
               let ok=ok+1
            fi
    done
done < "$REPO_FILE"
