#!/bin/sh

if [ $# -lt 1 ] ; then
  echo "First argument folder path to dashboards. Second argument kubeconfig file"
  exit 1
fi

if [ $# -ge 2 ] ; then
  export KUBECONFIG=$2
fi

KIBANA_URL=$(kubectl get cm global -o jsonpath={.data.mosip-kibana-host})
INSTALL_NAME=$(kubectl get cm global -o jsonpath={.data.installation-name})

read -p "Give the installation name: (default: $INSTALL_NAME) " TO_REPLACE
TO_REPLACE=${TO_REPLACE:-$INSTALL_NAME}

TEMP_OBJ_FILE="/tmp/temp_kib_obj.ndjson"

for file in $1/* ; do
  cp $file $TEMP_OBJ_FILE

  if [ $# -ge 2 ] ; then
    sed -i.bak "s/___DB_PREFIX_INDEX___/$TO_REPLACE/g" $TEMP_OBJ_FILE
  fi
  echo ;
  echo "Installing : $file"
  curl -XPOST "https://$KIBANA_URL/api/saved_objects/_import" -H "kbn-xsrf: true" --form file=@$TEMP_OBJ_FILE

  rm $TEMP_OBJ_FILE "$TEMP_OBJ_FILE.bak"
done
