#!/bin/sh

# for connectors
cd /connector_api_calls
EXTENSION=".api"
conn_list=(*.api)

for file in "${conn_list[@]}" ; do
  fname=$(basename $file $EXTENSION)
  if [ "connector_${!fname}" == "true" ] ; then
    sh -x $file
  fi
done

# for dashboards
cd /dashboards
# todo
