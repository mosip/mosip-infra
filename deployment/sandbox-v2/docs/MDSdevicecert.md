For trust validation in registration client we need to make sure the device certificates for the MDS are available in MOSIP's master.ca_cert_store table. Here, we expect the chain of certificates to be available so that these certificates gets synced to the registration client trust store (in derby database) and are used for trust validation when MDS signs any response using the device keys.

## Pre-requisites
We need to make sure that the MOSIP ROOT and MOSIP PMS certificates are available in MOSIP's master.ca_cert_store table. If not these needs to be added post deployment may be using a database script. In future releases this will be added automatically by the key manager when the these root keys are generated or updated.

The certificate uploaded by the device provider should be a CA signed certificate and the CA should be a approved CA by MOSIP. Hence we need to register the CA in MOSIP by uploading the CA certificate before the device provider uploads the certificate in PMS.

### Steps to add the MOSIP ROOT certificate

* Get a authentication token
    Request URL: `POST https://qa.mosip.net/v1/authmanager/authenticate/clientidsecretkey`
    Request Body:
    ```JSON
    {
	  "id": "string",
	  "metadata": {},
	  "request": {
	    "appId": "ida",
	    "clientId": "mosip-ida-client",
	    "secretKey": "<secret>"
	  },
	  "requesttime": "2018-12-10T06:12:52.994Z",
	  "version": "string"
	}
    ```
    Response:
    ```JSON
    {
        "id": "string",
        "version": "string",
        "responsetime": "2021-05-06T08:29:04.570Z",
        "metadata": null,
        "response": {
            "status": "Success",
            "message": "Clientid and Token combination had been validated successfully"
        },
        "errors": null
    }
    ```

* Fetch the ROOT certificate from MOSIP's key manager API.
    Request URL: `GET https://qa.mosip.net/v1/keymanager/getCertificate?applicationId=ROOT`
    Response:
    ```JSON
    {
        "id": null,
        "version": null,
        "responsetime": "2021-05-06T08:42:34.697Z",
        "metadata": null,
        "response": {
            "certificate": "-----BEGIN CERTIFICATE-----\nMIIDmjCCAoKgAwIBAgIIaKo5PFVO9QcwDQYJKoZIhvcNAQELBQAwcDELMAkGA1UE\nBhMCSU4xCzAJBgNVBAgMAktBMRIwEAYDVQQHDAlCQU5HQUxPUkUxDTALBgNVBAoM\nBElJVEIxGjAYBgNVBAsMEU1PU0lQLVRFQ0gtQ0VOVEVSMRUwEwYDVQQDDAx3d3cu\nbW9zaXAuaW8wHhcNMjEwNDMwMTMyMjAzWhcNMjQwNDI5MTMyMjAzWjB2MQswCQYD\nVQQGEwJJTjELMAkGA1UECAwCS0ExEjAQBgNVBAcMCUJBTkdBTE9SRTENMAsGA1UE\nCgwESUlUQjEgMB4GA1UECwwXTU9TSVAtVEVDSC1DRU5URVIgKFBNUykxFTATBgNV\nBAMMDHd3dy5tb3NpcC5pbzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB\nALWmQA+UlfT4n/DBUUyixUvOeH9siJa0UgcHRmYAkoVDLspPdc7lxPKcuHkQybAW\n9AMs1RFxtsF2dUEtXGpxvrP1Y4cVLxICZRJWvKlxOZ2Sj03zhqMH3hDXNtoPpEiU\nXdw3W6WSBTcdZJ2rBNk3ucV3knE4FnBLJ6P+SxFw3uB6gVwUEASJRs2JnJVdhD2H\n4bEjm/t1fpKEC1rUdmFi6ZQhjseVWSUh7Jwv4FCXieBtIL4MUs3WbkXIybytLsf6\nXHqL5JzEn0dOHKYiA9bqjlmXh8l7Z7r91E+UwCsb9lmiHlXm3g0GegRXHZwArkad\nIbNjAcTwzDHQZ+zQhKhiXjcCAwEAAaMyMDAwDwYDVR0TAQH/BAUwAwEB/zAdBgNV\nHQ4EFgQUvkXvEFHK3kJjsjPSRvEp6QRPjt4wDQYJKoZIhvcNAQELBQADggEBALiF\n5Xurad1U7SxTgviV1SeA1mInFw9jqD7y/xK/NFsPnV9Dm673u4ll2z+EqM19NeAn\nZEsIdOgWTm8+5sZDO02PksC7z96O7R/ZIL4eium1o4Mm0WdO6jhDR/4jVkvXu0PF\nU/UHSLKrS3XGRcHATAM5vWf8exla3S2OeNR+M+edSWv+2XdCpOJsFadIlFpvyHK8\nukD1iHK6GBDnMoUzCxmfyJ/kkStChDaLudoHmRokVMFrNEmvh3vyASbtNGg7du/2\n9YS2bxzpgAz99I719r/zyiXEJ5yheJKtlugvgacgwie+FFs+AZ81PTYU7T/8AJR+\n7gas1HC23MdBp4e7l0c=\n-----END CERTIFICATE-----\n",
            "certSignRequest": null,
            "issuedAt": "2021-04-30T13:22:03.000Z",
            "expiryAt": "2024-04-29T13:22:03.000Z",
            "timestamp": "2021-05-06T08:42:34.698Z"
        },
        "errors": null
    }
    ```
* Insert the certificate in the master.ca_cert_store table

### Steps to add the MOSIP ROOT certificate

* Get a authentication token same as before
* Fetch the PMS certificate from MOSIP's key manager API.
    Request URL: `GET https://qa.mosip.net/v1/keymanager/getCertificate?applicationId=PMS`
    Response:
    ```JSON
    {
        "id": null,
        "version": null,
        "responsetime": "2021-05-06T08:42:34.697Z",
        "metadata": null,
        "response": {
            "certificate": "-----BEGIN CERTIFICATE-----\nMIIDmjCCAoKgAwIBAgIIaKo5PFVO9QcwDQYJKoZIhvcNAQELBQAwcDELMAkGA1UE\nBhMCSU4xCzAJBgNVBAgMAktBMRIwEAYDVQQHDAlCQU5HQUxPUkUxDTALBgNVBAoM\nBElJVEIxGjAYBgNVBAsMEU1PU0lQLVRFQ0gtQ0VOVEVSMRUwEwYDVQQDDAx3d3cu\nbW9zaXAuaW8wHhcNMjEwNDMwMTMyMjAzWhcNMjQwNDI5MTMyMjAzWjB2MQswCQYD\nVQQGEwJJTjELMAkGA1UECAwCS0ExEjAQBgNVBAcMCUJBTkdBTE9SRTENMAsGA1UE\nCgwESUlUQjEgMB4GA1UECwwXTU9TSVAtVEVDSC1DRU5URVIgKFBNUykxFTATBgNV\nBAMMDHd3dy5tb3NpcC5pbzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB\nALWmQA+UlfT4n/DBUUyixUvOeH9siJa0UgcHRmYAkoVDLspPdc7lxPKcuHkQybAW\n9AMs1RFxtsF2dUEtXGpxvrP1Y4cVLxICZRJWvKlxOZ2Sj03zhqMH3hDXNtoPpEiU\nXdw3W6WSBTcdZJ2rBNk3ucV3knE4FnBLJ6P+SxFw3uB6gVwUEASJRs2JnJVdhD2H\n4bEjm/t1fpKEC1rUdmFi6ZQhjseVWSUh7Jwv4FCXieBtIL4MUs3WbkXIybytLsf6\nXHqL5JzEn0dOHKYiA9bqjlmXh8l7Z7r91E+UwCsb9lmiHlXm3g0GegRXHZwArkad\nIbNjAcTwzDHQZ+zQhKhiXjcCAwEAAaMyMDAwDwYDVR0TAQH/BAUwAwEB/zAdBgNV\nHQ4EFgQUvkXvEFHK3kJjsjPSRvEp6QRPjt4wDQYJKoZIhvcNAQELBQADggEBALiF\n5Xurad1U7SxTgviV1SeA1mInFw9jqD7y/xK/NFsPnV9Dm673u4ll2z+EqM19NeAn\nZEsIdOgWTm8+5sZDO02PksC7z96O7R/ZIL4eium1o4Mm0WdO6jhDR/4jVkvXu0PF\nU/UHSLKrS3XGRcHATAM5vWf8exla3S2OeNR+M+edSWv+2XdCpOJsFadIlFpvyHK8\nukD1iHK6GBDnMoUzCxmfyJ/kkStChDaLudoHmRokVMFrNEmvh3vyASbtNGg7du/2\n9YS2bxzpgAz99I719r/zyiXEJ5yheJKtlugvgacgwie+FFs+AZ81PTYU7T/8AJR+\n7gas1HC23MdBp4e7l0c=\n-----END CERTIFICATE-----\n",
            "certSignRequest": null,
            "issuedAt": "2021-04-30T13:22:03.000Z",
            "expiryAt": "2024-04-29T13:22:03.000Z",
            "timestamp": "2021-05-06T08:42:34.698Z"
        },
        "errors": null
    }
    ```
* Insert the certificate in the master.ca_cert_store table

### Steps to add a CA in MOSIP

* Get a authentication token
    Request URL: `POST https://qa.mosip.net/v1/authmanager/authenticate/clientidsecretkey`
    Request Body:
    ```JSON
    {
	  "id": "string",
	  "metadata": {},
	  "request": {
	    "appId": "ida",
	    "clientId": "mosip-pms-client",
	    "secretKey": "<secret>"
	  },
	  "requesttime": "2018-12-10T06:12:52.994Z",
	  "version": "string"
	}
    ```
    Response:
    ```JSON
    {
        "id": "string",
        "version": "string",
        "responsetime": "2021-05-06T08:29:04.570Z",
        "metadata": null,
        "response": {
            "status": "Success",
            "message": "Clientid and Token combination had been validated successfully"
        },
        "errors": null
    }
    ```
* Upload CA Certificate
    Request URL: `POST https://qa.mosip.net/v1/partnermanager/partners/certificate/ca/upload`
    Request Body:
    ```JSON
    {
        "id": "string",
        "metadata": {},
        "request": {
            "certificateData": "<CA certificate>",
            "partnerDomain": "DEVICE"
        },
        "requesttime": "2021-03-24T08:24:13.349Z",
        "version": "string"
    }
    ```

## Procedure
Once the ROOT certificates are in Master DB and the Device Provider CA certificate is in MOSIP. We can proceed with the upload of device provider certificate.

### Steps to add partner & partner certificate

* Create a device partner
    Request URL: `POST https://qa.mosip.net/v1/partnermanager/partners`
    Request Body: 
    ```JSON
    {
        "id": "string",
        "metadata": {},
        "request": {
            "address": "ABC Address",
            "contactNumber": "9999999999",
            "emailId": "abc@gmail.com",
            "organizationName": "ABC",
            "partnerId": "ABC123",
            "partnerType": "Device_Provider",
            "policyGroup": ""
        },
        "requesttime": "",
        "version": "string"
    }
    ```
* Upload the device provider certificate
    Note: We need to make sure that the 'O' element in the certificate should be same as the Organization Name of the partner and the CA who signed the certificate should be available in MOSIP.

    Request URL: `POST https://qa.mosip.net/v1/partnermanager/partners/certificate/upload`
    Request Body: 
    ```JSON
    {
        "id": "string",
        "metadata": {},
        "request": {
            "certificateData": "<certificate data>",
            "partnerDomain": "DEVICE",
            "partnerId": "ABC123"
        },
        "requesttime": "",
        "version": "string"
    }
    ```
    Response:
    ```JSON
    {
        "id": "string",
        "metadata": {},
        "response": {
            "certificateId": "<Certificate ID>",
            "signedCertificateData": "<MOSIP Signed Certificate>",
            "timestamp": "2021-05-06T09:11:45.952Z"
        },
        "responsetime": "2021-03-24T08:24:13.349Z",
        "version": "string"
        "errors": null
    }
    ```

### Steps to build mock MDS
 We should now create a key store and use it in MOCK MDS for creating MDS Device Keys.
