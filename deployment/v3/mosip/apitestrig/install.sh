#!/bin/sh
# Installs apitestrig
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=apitestrig
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=disabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

SERVER_HOST=$( kubectl -n default get cm global -o json  |jq -r '.data."installation-domain"' )
kubectl -n $NS delete --ignore-not-found=true configmap db-cm
kubectl -n $NS create configmap db-cm --from-literal=db-port=5432 --from-literal=db-su-user=postgres --from-literal=db-server=$SERVER_HOST

echo "Adding s3 configmap"
kubectl -n $NS delete --ignore-not-found=true configmap s3
S3_HOST='http://minio.minio:9000'
kubectl -n s3 get cm s3 -o yaml | sed 's/kind:/  s3-host: http:\/\/minio\.minio\:9000\nkind\:/g' | sed "s/namespace: s3/namespace: $NS/g"  | kubectl -n $NS create -f -


API_INTERNAL_HOST=$( kubectl -n default get cm global -o json  |jq -r '.data."mosip-api-internal-host"' )
ENV_USER=$( kubectl -n default get cm global -o json  |jq -r '.data."installation-name"' )

kubectl -n $NS delete --ignore-not-found=true configmap apitestrig
kubectl -n $NS create configmap apitestrig  --from-literal=ENV_USER=$ENV_USER \
--from-literal=ENV_ENDPOINT=https://$API_INTERNAL_HOST

echo Copy secrets
./copy_secrets.sh

DB_SU_PASSWORD=$( kubectl -n postgres get secrets postgres-postgresql -o json | jq -r '.data."postgresql-password"' | base64 -d )
kubectl -n $NS delete --ignore-not-found=true secret db-secrets
kubectl -n $NS create secret generic db-secrets --from-literal="db-su-password=$DB_SU_PASSWORD"


read -p "Please enter the time(hr) to run the cronjob every day (time: 0-23) : " time
if [ -z "$time" ]; then
   echo "ERROT: Time cannot be empty; EXITING;";
   exit 1;
fi
if ! [ $time -eq $time ] 2>/dev/null; then
   echo "ERROR: Time $time is not a number; EXITING;";
   exit 1;
fi
if [ $time -gt 23 ] || [ $time -lt 0 ] ; then
   echo "ERROR: Time should be in range ( 0-23 ); EXITING;";
   exit 1;
fi

echo Installing apitestrig
helm -n $NS install apitestrig mosip/apitestrig --set crontime="0 $time * * *" -f values.yaml --wait --version $CHART_VERSION
echo Installed apitestrig.

