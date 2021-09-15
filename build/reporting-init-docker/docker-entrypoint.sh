#!/bin/bash

# for connectors
echo -e "\n-->> Deploying Connectors <<---\n"
cd /connector_api_calls
EXTENSION=".api"
conn_list=(*.api)

for file in "${conn_list[@]}" ; do
  fname=$(basename $file $EXTENSION)
  fname=${fname#*.}
  fname=connector_$fname
  if [ "${!fname}" = "true" ] ; then
    echo -e "\n>> $file\n"
    sh -x $file
    sleep 10s
  fi
done

unset conn_list

# for other connectors mounted through configmap
echo -e "\n-->> Deploying Other Connectors from configmaps <<---\n"
cd /other_connectors
dir_list=($(ls))

for dir in "${dir_list[@]}" ; do
  cd /other_connectors/$dir
  echo -e "\n-> $PWD\n"
  conn_list=(*.api)
  for file in "${conn_list[@]}" ; do
    echo -e "\n>> $file\n"
    sh -x $file
    sleep 10s
  done
  unset conn_list
done

unset dir_list

# for dashboards
echo -e "\n-->> Deploying Kibana Objects <<---\n"
cd /kibana_saved_objects
EXTENSION=".ndjson"
kib_list=(*.ndjson)

for file in "${kib_list[@]}" ; do
  fname=$(basename $file $EXTENSION)
  fname=${fname#*.}
  fname=kibana_saved_object_$fname
  if [ "${!fname}" = "true" ] ; then
    echo -e "\n>> $file\n"
    sed -i "s/___DB_PREFIX_INDEX___/$DB_PREFIX_INDEX/g" $file
    curl -XPOST $KIBANA_URL/api/saved_objects/_import?createNewCopies=true -H "kbn-xsrf: true" --form file=@$file
    sleep 10s
  fi
done

# for other kibana stuff mounted through configmap
echo -e "\n-->> Deploying Other Kibana Objects from configmaps <<---\n"
cd /other_kibana_saved_objects
dir_list=($(ls))

for dir in "${dir_list[@]}" ; do
  cd /other_kibana_saved_objects/$dir
  kib_list=(*.ndjson)
  echo -e "\n-> $PWD\n"
  for file in "${kib_list[@]}" ; do
    echo -e "\n>> $file\n"
    sed -i "s/___DB_PREFIX_INDEX___/$DB_PREFIX_INDEX/g" $file
    curl -XPOST $KIBANA_URL/api/saved_objects/_import?createNewCopies=true -H "kbn-xsrf: true" --form file=@$file
    sleep 10s
  done
  unset kib_list
done

unset dir_list
