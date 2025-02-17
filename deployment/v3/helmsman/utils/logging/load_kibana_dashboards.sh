#!/bin/sh

if [ $# -lt 1 ] ; then
  echo "Usage: ./load_kibana_dashboards.sh <dashboards folder> [kubeconfig file]"
  exit 1
fi

if [ $# -ge 2 ] ; then
  export KUBECONFIG=$2
fi

KIBANA_URL=$(kubectl get cm global -o jsonpath={.data.mosip-kibana-host})
read -p "Give Kibana Host Name (Example: \"kibana.sandbox.mosip.net\" or \"box.mosip.net/kibana\"): (default: $KIBANA_URL) " TO_REPLACE
KIBANA_URL=${TO_REPLACE:-$KIBANA_URL}
unset TO_REPLACE

INSTALL_NAME=$(kubectl get cm global -o jsonpath={.data.installation-name})
read -p "Give the installation name (Use \"_\" instead of \"-\". And no capitals/symbols.): (default: $INSTALL_NAME) " TO_REPLACE
INSTALL_NAME=${TO_REPLACE:-$INSTALL_NAME}
unset TO_REPLACE

TEMP_OBJ_FILE="/tmp/temp_kib_obj.ndjson"

for file in ${1%/}/*.ndjson ; do
  cp $file $TEMP_OBJ_FILE
  sed -i.bak "s/___DB_PREFIX_INDEX___/$INSTALL_NAME/g" $TEMP_OBJ_FILE
  echo ;
  echo "Loading : $file"
  curl -XPOST "https://${KIBANA_URL%/}/api/saved_objects/_import" -H "kbn-xsrf: true" --form file=@$TEMP_OBJ_FILE
  rm $TEMP_OBJ_FILE "$TEMP_OBJ_FILE.bak"
done
