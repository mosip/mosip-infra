#!/usr/bin/env bash

bash auth.sh
cat temp.txt
TOKEN=$(cat -n temp.txt | sed -n '/authorization:/,/\;.*/p' |  sed 's/.*authorization://; s/$\n.*//' | awk 'NR==1{print $1}')
echo $TOKEN
RESULT=`curl -X "GET" \
  --cookie "Authorization=$TOKEN" \
  "$host_url_env/v1/keymanager/getCertificate?applicationId=KERNEL&referenceId=SIGN" \
  -H "accept: */*"`
echo $RESULT
CERT=$(echo $RESULT | sed 's/.*certificate\":\"//g' | sed 's/\".*//g')
echo $CERT | sed -e 's/\\n/\n/g' > cert.pem
cat cert.pem
openssl x509 -pubkey -noout -in cert.pem  > pubkey.pem
cat pubkey.pem
sed -i "s&replace-public-key&$(cat pubkey.pem | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\\\n/g')&g" ./public-key.json
