#!/usr/bin/env bash

#bash auth.sh > temp.txt
TOKEN=$(cat -n temp.txt | sed -n '/authorization:/,/\;.*/p' |  sed 's/.*authorization://; s/$\n.*//' | awk 'NR==1{print $1}')
#echo result is $RESULT
echo "token is $TOKEN"

RESULT1=`curl -v -X "GET" \
  -H "Authorization: $TOKEN" \
  "https://dev2.mosip.net/v1/keymanager/getCertificate?applicationId=KERNEL&referenceId=SIGN" \
  -H "accept: */*"`

CERT=$(echo $RESULT1 | sed 's/.*certificate\":\"//g' | sed 's/\".*//g')
echo $CERT  > $base_path/public-key.json