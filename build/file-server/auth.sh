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