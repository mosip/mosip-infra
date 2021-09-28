#!/bin/sh

KIBANA_URL="https://kibana.mosip.net"

TEMP_OBJ_FILE="temp_kib_obj.ndjson"
cp $1 $TEMP_OBJ_FILE

if [ $# -ge 2 ] ; then
  sed -i "s/___DB_PREFIX_INDEX___/$2/g" $TEMP_OBJ_FILE
fi

curl -XPOST "$KIBANA_URL/api/saved_objects/_import" -H "kbn-xsrf: true" --form file=@$TEMP_OBJ_FILE

rm $TEMP_OBJ_FILE
