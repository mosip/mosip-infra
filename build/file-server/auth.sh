#!/usr/bin/env bash

echo "* Request for authorization"
curl -v -X "POST" \
  "$host_url_env/v1/authmanager/authenticate/clientidsecretkey" \
  -H "accept: */*" \
  -H "Content-Type: application/json" \
  -d "{
  "id": "string",
  "version": "string",
  "requesttime": "2022-01-24T15:39:15.753Z",
  "metadata": {},
  "request": {
    "clientId": "$clientid_env",
    "secretKey": "$clientsecret_env",
    "appId": "admin"
  }
}" > temp.txt 2>&1 &