#!/bin/bash

#Usage: ./apply_policy.sh <policy file> <kube config file>

if [ $# -ge 2 ]; then
  export KUBECONFIG=$2
fi

temp_file="$1.tmp"
cp $1 $temp_file

for host_var in $(cat $temp_file | grep -oP '(?<=h__).*(?=__h)'); do
  host_name="$(kubectl get cm global -o jsonpath={.data.$host_var})"
  sed -i "s;h__${host_var}__h;${host_name};g" $temp_file
done

jwks_uri=$(cat $temp_file | grep -oP '(?<=rjwks__).*(?=__rjwks)')
remote_local_jwks=$(curl -s "$jwks_uri")
sed -i "s;rjwks__${jwks_uri}__rjwks;${remote_local_jwks};g" $temp_file

kubectl apply -f $temp_file
rm $temp_file
