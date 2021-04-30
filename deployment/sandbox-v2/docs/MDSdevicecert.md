# MDS device certificate exchange guide so that it will be able to create packets and upload
The certificate will be uploaded as CA certificate. These certificates will be saved in master data in keymanager db in ca_cert_store table. As well as a reference copy will be reflected in the ca_cert_store of master table. Then fetched in the sync of the master data sync and stored in local DB of the Reg-client.
The device certificate is the certificate coming from the MDS.

* Below are the steps which needed to be followed for abis certificate exchange once after the depoloyment is done.

- Authenticate yourself and get authorization token from authmanager swagger. Also adding the request after that which can be used.. please update the domain name in the request.

  * 1. SWAGGER URL:- ```https://minibox.mosip.net/v1/authmanager/swagger-ui.html#/authmanager/clientIdSecretKeyUsingPOST ```  hit authmanager section in try-out section.
	```
	{
	  "id": "string",
	  "metadata": {},
	  "request": {
	    "appId": "registrationclient",
	    "clientId": "mosip-pms-client",
	    "secretKey": "abc123"
	  },
	  "requesttime": "2018-12-10T06:12:52.994Z",
	  "version": "string"
	}
	```
  * 2. Upload CA certificate in the below SWAGGER URL:- ```https://minibox.mosip.net/v1/partnermanager/swagger-ui.html#/Partner%20Service%20Controller/uploadCACertificateUsingPOST``` Partner_Service_Controller --> /partners/certificate/ca/upload --> with below request
	- 1st Request: For Device certificate Exchange.
	```
	{
	  "id": "string",
	  "metadata": {},
	  "request": {
	    "certificateData": "-----BEGIN CERTIFICATE-----\nMIIDPzCCAiegAwIBAgIEYCFEgjANBgkqhkiG9w0BAQsFADBSMQswCQYDVQQGEwJJ\nTjESMBAGA1UECAwJS2FybmF0YWthMQ4wDAYDVQQKDAVNb3NpcDEOMAwGA1UECwwF\nTW9zaXAxDzANBgNVBAMMBlJvb3RDQTAeFw0yMTAyMDgxNDAyNDJaFw0zMTAyMDgx\nNDAyNDJaMFIxCzAJBgNVBAYTAklOMRIwEAYDVQQIDAlLYXJuYXRha2ExDjAMBgNV\nBAoMBU1vc2lwMQ4wDAYDVQQLDAVNb3NpcDEPMA0GA1UEAwwGUm9vdENBMIIBIjAN\nBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAz9kaCs4Yrh2mMFx/wGV42Tn7vM9d\nt2au3JOWu/fbeaNk8/TgNEA1GrVerqagcRDDo+6jBDbX7XO9iRHX1wmIcVkH7osa\ncMKGfYzZbvkWjGFRCam10xLGyczSeDiIIj+H3eLXzTP0iZBcVyw40EMLWk7BHld+\neFY1XS+EDPIv6snjIxWDEd+wND1tOvWgPsS7mYy8Mn9QRYZXH9KW8/nW0bf/Z74U\nd89PtXl3WSSrrRZSQofGDwM5RPOEzrYcurZowwWLWmgAmvcsATxhOAiKe6e6tvbD\nyXTC8+9CRv22zGTcasI5QOYzGaj6wMKr9h2WgAY1LJFBIkEjf1ykWGlTbQIDAQAB\nox0wGzAMBgNVHRMEBTADAQH/MAsGA1UdDwQEAwIBBjANBgkqhkiG9w0BAQsFAAOC\nAQEAzWge0dKje1/opIyiho0e6p6a/M/UD05bNLg7XD6uMqJAT9C1YTwq77OD0nrc\nZpMQoQ4zCFEbGoPvHWzW0Isc7Y3F40YI8bQdmEQtJuiqsCUQ8XW3b4YDTH6VM5go\n+VZgoRucIRBwCAss1tMrxjT3lMWwuyA9DaOkryRW/m9QmlLoTWLQabi/pO+FS+oy\nWYYxJOzvqC3xUTYHi+DzlLSWR08NE7gdHrD4aAHYLPIyzgVuToztB7PYmbuOnKmS\nM9sHlKqgpN7/AgvTOFOEX5mi5BcPGKagryTfipwLVyWaQBDCcVNkAtoLTYPCTEAj\nUhONf7GpbeehitYjHQoknr21EA==\n-----END CERTIFICATE-----",
	    "partnerDomain": "DEVICE"
	  },
	  "requesttime": "2021-03-24T08:24:13.349Z",
	  "version": "string"
	}
	```
	-2nd Request: For FTM certificate Exchange.
	```
	{
          "id": "string",
          "metadata": {},
          "request": {
            "certificateData": "-----BEGIN CERTIFICATE-----\nMIIDPzCCAiegAwIBAgIEYCFEgjANBgkqhkiG9w0BAQsFADBSMQswCQYDVQQGEwJJ\nTjESMBAGA1UECAwJS2FybmF0YWthMQ4wDAYDVQQKDAVNb3NpcDEOMAwGA1UECwwF\nTW9zaXAxDzANBgNVBAMMBlJvb3RDQTAeFw0yMTAyMDgxNDAyNDJaFw0zMTAyMDgx\nNDAyNDJaMFIxCzAJBgNVBAYTAklOMRIwEAYDVQQIDAlLYXJuYXRha2ExDjAMBgNV\nBAoMBU1vc2lwMQ4wDAYDVQQLDAVNb3NpcDEPMA0GA1UEAwwGUm9vdENBMIIBIjAN\nBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAz9kaCs4Yrh2mMFx/wGV42Tn7vM9d\nt2au3JOWu/fbeaNk8/TgNEA1GrVerqagcRDDo+6jBDbX7XO9iRHX1wmIcVkH7osa\ncMKGfYzZbvkWjGFRCam10xLGyczSeDiIIj+H3eLXzTP0iZBcVyw40EMLWk7BHld+\neFY1XS+EDPIv6snjIxWDEd+wND1tOvWgPsS7mYy8Mn9QRYZXH9KW8/nW0bf/Z74U\nd89PtXl3WSSrrRZSQofGDwM5RPOEzrYcurZowwWLWmgAmvcsATxhOAiKe6e6tvbD\nyXTC8+9CRv22zGTcasI5QOYzGaj6wMKr9h2WgAY1LJFBIkEjf1ykWGlTbQIDAQAB\nox0wGzAMBgNVHRMEBTADAQH/MAsGA1UdDwQEAwIBBjANBgkqhkiG9w0BAQsFAAOC\nAQEAzWge0dKje1/opIyiho0e6p6a/M/UD05bNLg7XD6uMqJAT9C1YTwq77OD0nrc\nZpMQoQ4zCFEbGoPvHWzW0Isc7Y3F40YI8bQdmEQtJuiqsCUQ8XW3b4YDTH6VM5go\n+VZgoRucIRBwCAss1tMrxjT3lMWwuyA9DaOkryRW/m9QmlLoTWLQabi/pO+FS+oy\nWYYxJOzvqC3xUTYHi+DzlLSWR08NE7gdHrD4aAHYLPIyzgVuToztB7PYmbuOnKmS\nM9sHlKqgpN7/AgvTOFOEX5mi5BcPGKagryTfipwLVyWaQBDCcVNkAtoLTYPCTEAj\nUhONf7GpbeehitYjHQoknr21EA==\n-----END CERTIFICATE-----"
            "partnerDomain": "FTM"
          },
          "requesttime": "2021-03-24T08:24:13.349Z",
          "version": "string"
        }
	```
# Troubleshooting

- Please check if the domain name is correctly replaced.
- In case of errors related to timestamp please update the latest timestamp in the request.
- If the Swagger links are not available check if the services are running fine. 
	swagger 1:- kernel-Auth-service.
	swagger 2:- pms services.
	swagger 3:- pms services.
- In case of error `certifcate data already exist` in response message please ignore and continue as certificate is already exchanged.
- For other descrepencies raise a github issue.
