#!/bin/bash

# for connectors
CONNECTORS_DIR="/connectors"
echo -e "\n-->> Deploying Connectors from configmaps <<---\n"
cd $CONNECTORS_DIR
dir_list=($(ls))

for dir in "${dir_list[@]}" ; do
  cd "$CONNECTORS_DIR/$dir"
  echo -e "\n-> $PWD\n"
  conn_list=(*.api)
  for file in "${conn_list[@]}" ; do
    echo -e "\n>> $file\n"
    sh -x $file
  done
  unset conn_list
  sleep $DELAY_BETWEEN_CONNECTORS
done

unset dir_list

# for dashboards

# BIG TODO: The following lines while importing objects, the api call doesnt take care if there is a clash with previous objects with same id
# Check if that is a problem

KIB_DIR="/kibana_saved_objects"
echo -e "\n-->> Deploying Kibana Objects from configmaps <<---\n"
cd $KIB_DIR
dir_list=($(ls))

for dir in "${dir_list[@]}" ; do
  cd $KIB_DIR/$dir
  kib_list=(*.ndjson)
  echo -e "\n-> $PWD\n"
  for file in "${kib_list[@]}" ; do
    echo -e "\n>> $file\n"
    sed -i "s/___DB_PREFIX_INDEX___/$DB_PREFIX_INDEX/g" $file
    curl -XPOST $KIBANA_URL/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@$file
  done
  unset kib_list
done

unset dir_list
