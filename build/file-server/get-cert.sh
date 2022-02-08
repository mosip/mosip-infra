#!/usr/bin/env bash

bash auth.sh
TOKEN=$(cat -n temp.txt | sed -n '/authorization:/,/\;.*/p' |  sed 's/.*authorization://; s/$\n.*//' | awk 'NR==1{print $1}')

RESULT=`curl -X "GET" \
  --cookie "Authorization=$TOKEN" \
  "$host_url_env/v1/keymanager/getCertificate?applicationId=KERNEL&referenceId=SIGN" \
  -H "accept: */*"`

CERT=$(echo $RESULT | sed 's/.*certificate\":\"//g' | sed 's/\".*//g')
sed -i 's/replace-public-key/$CERT/' $base_path/public-key.json