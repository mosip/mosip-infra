#!/usr/bin/env bash

echo "* Request for authorization"
curl -v -X 'POST' \
  'https://dev2.mosip.net/v1/authmanager/authenticate/clientidsecretkey' \
  -H 'accept: */*' \
  -H 'Content-Type: application/json' \
  -d '{
  "id": "string",
  "version": "string",
  "requesttime": "2022-01-24T15:39:15.753Z",
  "metadata": {},
  "request": {
    "clientId": "mosip-admin-client",
    "secretKey": "xyz123",
    "appId": "admin"
  }
}' > temp.txt 2>&1 &