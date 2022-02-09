#!/usr/bin/env bash

#echo "* Request for authorization"
curl -s -D - -o /dev/null -X "POST" \
  "$host_url_env/v1/authmanager/authenticate/clientidsecretkey" \
  -H "accept: */*" \
  -H "Content-Type: application/json" \
  -d '{
  "id": "string",
  "version": "string",
  "requesttime": "'$date_env'",
  "metadata": {},
  "request": {
    "clientId": "mosip-regproc-client",
    "secretKey": "'$clientsecret_env'",
    "appId": "regproc"
  }
}' > temp.txt 2>&1 &

sleep 10

TOKEN=$(cat -n temp.txt | sed -n '/Authorization:/,/\;.*/p' |  sed 's/.*Authorization://; s/$\n.*//' | awk 'NR==1{print $1}')

curl -v -X "GET" \
  -H "Accept: application/json" \
  --cookie "Authorization=$TOKEN" \
  "$host_url_env/v1/keymanager/getCertificate?applicationId=KERNEL&referenceId=SIGN" > result.txt

RESULT=$(cat result.txt)
CERT=$(echo $RESULT | sed 's/.*certificate\":\"//g' | sed 's/\".*//g')
echo $CERT | sed -e 's/\\n/\n/g' > cert.pem
openssl x509 -pubkey -noout -in cert.pem  > pubkey.pem
sed -i "s&replace-public-key&$(cat pubkey.pem | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\\\n/g')&g" $base_path/public-key.json

echo "public key creation complete"

exec "$@"
