# Print service flow
Print-Service Flow
Partner Id : mpartner-default-print

Relative swagger url for credential related APIs: _https://{host}/v1/credentialrequest/swagger-ui.html_

## Step 1: Get all VIDs

Database - mosip_idmap

Table - vid

Query: select vid from vid where vidtyp_code = 'PERPETUAL' and expiry_dtimes > now() and status_code = 'ACTIVE' 

## Step 2: Authentication & Authorization
Request URL: _https://{base_url}/v1/authmanager/authenticate/clientidsecretkey_

Request type: POST

Request body:
```json
{
    "id": "string",
    "metadata": {},
    "request": {
        "appId": "<appId; configuration paramenter>",
        "clientId": "<clientId; configuration paramenter>",
        "secretKey": "<secretKey; configuration paramenter>"
    },
    "requesttime": "<timestamp>",
    "version": "string"
}
```

## Step 3: Credential request generator

To Access any API, you have to login into below URL

Request URL: _https://{base_url}/v1/credentialrequest/requestgenerator

Request type: POST

Request body:
```json
{
    "id": "string",
    "metadata": {},
    "request": {
        "additionalData": {},
        "credentialType": "<euin/reprint/qrcode; configuration paramenter>",
        "encrypt": false,
        "encryptionKey": "",
        "id": "<vid>",
        "issuer": "<partner_id; configuration paramenter>",
        "recepiant": "",
        "sharableAttributes": [],
        "user": "re_print_script"
    },
    "requesttime": "<timestamp>",
    "version": "string"
}
```

Response body:
```json
{
    "errors": [
        {
            "errorCode": "string",
            "message": "string"
        }
    ],
    "id": "string",
    "response": {
        "id": "string",
        "requestId": "string"
    },
    "responsetime": "string",
    "version": "string"
}
```
