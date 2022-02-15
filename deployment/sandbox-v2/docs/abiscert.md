# Abis certificate exchange guide so that it will be able to decrypt the packets

* Below are the steps which needed to be followed for abis certificate exchange once after the depoloyment is done.

- Authenticate yourself and get authorization token from authmanager swagger. Also adding the request after that which can be used.. please update the domain name in the request.

  * 1. SWAGGER URL:- ```https://minibox.mosip.net/v1/authmanager/swagger-ui.html#/authmanager/clientIdSecretKeyUsingPOST ```  hit authmanager section in try-out section.
	```
	{
	  "id": "string",
	  "metadata": {},
	  "request": {
	    "appId": "ida",
	    "clientId": "mosip-ida-client",
	    "secretKey": "abc123"
	  },
	  "requesttime": "2018-12-10T06:12:52.994Z",
	  "version": "string"
	}
	```
  * 2. Upload CA certificate in the below SWAGGER URL:- ```https://minibox.mosip.net/v1/partnermanager/swagger-ui.html#/Partner%20Service%20Controller/uploadCACertificateUsingPOST``` Partner_Service_Controller --> /partners/certificate/ca/upload --> with below request
	```
	{
	  "id": "string",
	  "metadata": {},
	  "request": {
	    "certificateData": "-----BEGIN CERTIFICATE-----\nMIIDyzCCArOgAwIBAgIUAP58nVW8pTXnWVSRRVPOkdOjc08wDQYJKoZIhvcNAQEL\nBQAwdTELMAkGA1UEBhMCSU4xEjAQBgNVBAgMCUthcm5hdGFrYTESMBAGA1UEBwwJ\nQmFuZ2Fsb3JlMR4wHAYDVQQKDBVtcGFydG5lci1kZWZhdWx0LWFiaXMxHjAcBgNV\nBAMMFW1wYXJ0bmVyLWRlZmF1bHQtYWJpczAeFw0yMjAyMDkwODI1NTBaFw0zMjAy\nMDcwODI1NTBaMHUxCzAJBgNVBAYTAklOMRIwEAYDVQQIDAlLYXJuYXRha2ExEjAQ\nBgNVBAcMCUJhbmdhbG9yZTEeMBwGA1UECgwVbXBhcnRuZXItZGVmYXVsdC1hYmlz\nMR4wHAYDVQQDDBVtcGFydG5lci1kZWZhdWx0LWFiaXMwggEiMA0GCSqGSIb3DQEB\nAQUAA4IBDwAwggEKAoIBAQC61/Jc+RqToNeBT/6X7l/e6xV8BAXlqMGZu2nJiXSX\nISZKPL9lqi561URmyZdA1Hk24yolYgciQr5LtJdoHioPKHi8yd+D50CDI74FwT93\n1UXb/+3Y3cVhGmYgELh87hrXhfbgbu1JwaU0iryNi8e3gI89LQTfM08hDtDkjRcJ\nfXGqf/YnbkaRQrzvYrK9IrMI4EAHzhO7CLZxRemnRTHC9H9HLgwnFzOci/PPjvXw\n9kPj2erUtkv77pSXePRzfinObO+SmZmw9JRyeEp9NgcLasXhKaCqKVyfGcz1Hjx+\n6xblGttqThHmU65ctOQLZ4Bsev5vrh/Om6eyfv0UmA7zAgMBAAGjUzBRMB0GA1Ud\nDgQWBBSKmYGWafsrVIe1ysXZedjL9wZxAzAfBgNVHSMEGDAWgBSKmYGWafsrVIe1\nysXZedjL9wZxAzAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQCZ\ngzaaUGQvGlDnWt94b2kVA5R+04xaHUqvtQKNoaDMbCrK6NUR/vODPxdhowzYbv6j\nVkYDlkT0WV7qvyEWyj6Ubyw0vR2rdrhDCQKLwy1CHS522bRdLoZreYhUA5/BZ3KU\nM2xL+ru+hBAeV1dt9Fo/j5zcDsyEDcJte2MontRplrWDSb7+v7FgQQtHq1pY6L3r\nftznhp5rqmvCC1YrMYh5W9F23ffLz23NObQFzg5nqpgwkHQsUxkEy2Ps4fWKvc0p\nOcCElVq2PLaxS2qZfYBu3KeP0QugeeIeLkuQQcrMLmlphVHl5JvIHW13qSJMqC5l\nEr7aYNy9EqIwFLHboNsP\n-----END CERTIFICATE-----",
	    "partnerDomain": "AUTH"
	  },
	  "requesttime": "2021-03-24T08:24:13.349Z",
	  "version": "string"
	}
	```
  * 3. Upload Partner certificate in the below SWAGGER URL:- ```https://minibox.mosip.net/v1/partnermanager/swagger-ui.html#/Partner%20Service%20Controller/uploadPartnerCertificateUsingPOST_1``` Partner_Service_Controller --> /partners/certificate/upload --> with below request
	```
	{
	  "id": "string",
	  "metadata": {},
	  "request": {
	    "certificateData": "-----BEGIN CERTIFICATE-----\nMIIEDDCCAvSgAwIBAgIBBDANBgkqhkiG9w0BAQsFADB1MQswCQYDVQQGEwJJTjES\nMBAGA1UECAwJS2FybmF0YWthMRIwEAYDVQQHDAlCYW5nYWxvcmUxHjAcBgNVBAoM\nFW1wYXJ0bmVyLWRlZmF1bHQtYWJpczEeMBwGA1UEAwwVbXBhcnRuZXItZGVmYXVs\ndC1hYmlzMB4XDTIyMDIwOTA4MjYzNFoXDTMyMDIwNzA4MjYzNFowdTELMAkGA1UE\nBhMCSU4xEjAQBgNVBAgMCUthcm5hdGFrYTESMBAGA1UEBwwJQmFuZ2Fsb3JlMR4w\nHAYDVQQKDBVtcGFydG5lci1kZWZhdWx0LWFiaXMxHjAcBgNVBAMMFW1wYXJ0bmVy\nLWRlZmF1bHQtYWJpczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMRq\ncyHKDVKjlaLa84F7ocH2q+sD6SOtvXUq+5eOhuiPuP//D0tM7cKzDttehidxnPjr\n36GwBxxRHlNn8+SRvbwUZOwUnxrHLbFT1bzR2OCgh+HndwZWYHAGr1h2eN/k1ANx\nFX5xrKehuYHHxQq2qCSiy2cB9ocTUNMFlv4DPGLYf48YaT0mUapelgYEQD2bWhqo\nPAmq87PIUMAuANsNE2GGkXmScNWElxIldW+cq+RIaUEujaDC9gDi2ymwiUCPHlDT\nrXxfDDmbjlBRaELOHQq4I6Y7bpDI/4e2e3egieOkj3TiMgkt3IL9kyPcFdmVnOEm\nj3FaPK9FuPLrbzqGua0CAwEAAaOBpjCBozAJBgNVHRMEAjAAMBEGCWCGSAGG+EIB\nAQQEAwIEEDAzBglghkgBhvhCAQ0EJhYkT3BlblNTTCBHZW5lcmF0ZWQgQ2xpZW50\nIENlcnRpZmljYXRlMB0GA1UdDgQWBBR8jRJkOIfZX3AajhAHBgA7w9r1ijAfBgNV\nHSMEGDAWgBSKmYGWafsrVIe1ysXZedjL9wZxAzAOBgNVHQ8BAf8EBAMCBeAwDQYJ\nKoZIhvcNAQELBQADggEBAKxoYaxflqzbJhndVYf0scvjuukG4BUaLD+b7g9hgNxJ\naCfnUURjs4kj4v/ahC8VzTSaHIfELu6g7W9Mub7452TfXGmb+3xBckIScwke8lpj\nNkpBTdsZZtWxXiMRa5R53z+K49aJRW+WmMqPTYJ4CxgcOBVvlnrGMQ4Ytubq9Srl\n4E4hGNIW13X+1wE6up5ZUHQe/pEkD1XqxURtESS/kFmLCkV/LjSWiIp74fuWum2O\nSJj8hEZD5AWpVVuGBaIssW8/Gc8hdLvI8rty6apqTZN6zWDwhs1ydEh9pWf6WbP/\nXA1/9oAVHNg2WfziSuNBqxowJ3kd0rrDgC5SO8RY0WI=\n-----END CERTIFICATE-----",
	    "partnerDomain": "Auth",
	    "partnerId": "mpartner-default-abis"
	  },
	  "requesttime": "",
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
- For other descrepencies raise a github issue.
