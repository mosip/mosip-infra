# Re-print flow
Print-Service Flow
Partner Id : mpartner-default-print

Relative swagger url for credential related APIs: _https://{host}/v1/credentialrequest/swagger-ui.html_

## Step 1: Get all VIDs

Database - mosip_idmap

Table - vid

Query: select vid from vid where vidtyp_code = 'PERPETUAL' and expiry_dtimes > now() and status_code = 'ACTIVE' 

## Step 2: Get additional info like center_id

### Get the UIN from the VID
Request URL: _https://{base_url}/idrepository/v1/identity/idvid/{vid}_

Request type: GET

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
      "status": "ACTIVATED",
      "identity": {
        "UIN": "7638798657"
      },
      "documents": null
    },
    "responsetime": "string",
    "version": "string"
}
```

### Get RID as per MOSIP v1.1.3
* Find modulo of UIN. It is configuration in id-repository-mz.properties (mosip.idrepo.modulo-value = 1000) 
* Get the SALT from idrepo.uin_hash_salt table using the modulo value as id `select salt from uin_hash_salt where id=%modulo;`
* Derive Hash using sha256 (UIN, SALT).
* Select regId from idrepo.uin, idrepo.uinHistory where uinHash = (modulo + "_" + Hash from step 3) `select reg_id as rid from uin where uin_hash=%modulo_hash;`

Steps to retrieve Center ID and Time Stamp of Packet from RID (for packets created with v1.1.3):
* Get the RID
* First 5 digits of the RID is the Center ID
* Last 14 digits of the RID is the timestamp when the packet was created in the format (YYYY-MM-DD-HH-MM-SS)

Ex- RID = 10001100460003420210216093456
Center ID = 10001
Timestamp = 2021-02-16 09:34:56

## Step 3: Authentication & Authorization
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

## Step 4: Credential request generator

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
