# Print certificate exchange guide so that the print requests will work in case of ref-impl mosip Print service

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
	    "certificateData": "-----BEGIN CERTIFICATE-----\nMIIDWTCCAkGgAwIBAgIUbaWqU+FfXlGZqyV8MDUqg/zwTD8wDQYJKoZIhvcNAQEL\nBQAwPDELMAkGA1UEBhMCSU4xCzAJBgNVBAgMAktBMQ4wDAYDVQQKDAVJSUlUQjEQ\nMA4GA1UEAwwHUGFydG5lcjAeFw0yMjAyMDgxMzQ1MzZaFw0zMjAyMDYxMzQ1MzZa\nMDwxCzAJBgNVBAYTAklOMQswCQYDVQQIDAJLQTEOMAwGA1UECgwFSUlJVEIxEDAO\nBgNVBAMMB1BhcnRuZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDK\n5qA9MorCLwCRurxQhC4/lI1XS5odm3pUm4YVvECYhJog4cNgrMxlPBMkKzGmNZw3\nP+WelA19gkBPHjpmP+demNQ8lebvPr3epfLxd7njIHgI6ZUQQf6792E6mja1A/E2\nFqDesLph+np5anpw4HjjipySehVDjZGJYs6zspgW9js0O8Dip7obP0zpK33qHreG\nwaSTajTYrHWkUpuIRMcW5DqGzOv06adw1L5PF9f5AU7c86OkGiRBmc+APqbXv3f9\nkdsACVrw+rmvnzCBeHGeC5rhVVTiPqHZ619odnRLdnZ9QpBQLjaG2ZseweYrfILC\n7FzAJmyytRVj+b1Gv7L5AgMBAAGjUzBRMB0GA1UdDgQWBBT2NPSFlaT+Y1wOzyZO\nYdKH442EwjAfBgNVHSMEGDAWgBT2NPSFlaT+Y1wOzyZOYdKH442EwjAPBgNVHRMB\nAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQAMf/5CW6ortaNeylXHATa0Ifut\nmkr6F5UXGg3+RmVjXXInBPP5LJnavbubVLXTPwAl3Rd7rZKvJlmhycJ+66798xTe\n5Jyinr8/Gx28hLzfr9U65nLiH/U1eZnAactqGowaH5dxTOHfdXA5VISqS0TLtUMf\nqZm9fZYeuopxCXSigX0rprqU33WEOX/0OKV0pHkFnEt28wahJ2YM0AcPS4n3LVEy\n+8mUGWizK7nOJkyQ/wCX7AtnhaCHnK+L1HmBViQmdfN7yznNUInO4WkcscrVWGWU\nf/SmEphqFj1LaOcYih1hccmJ0fPEOicqgCJ85OLnx9GQqhmnKO7nV87TNVF0\n-----END CERTIFICATE-----",
	    "partnerDomain": "Auth"
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
	    "certificateData": "-----BEGIN CERTIFICATE-----\nMIIDmjCCAoKgAwIBAgIBBDANBgkqhkiG9w0BAQsFADA8MQswCQYDVQQGEwJJTjEL\nMAkGA1UECAwCS0ExDjAMBgNVBAoMBUlJSVRCMRAwDgYDVQQDDAdQYXJ0bmVyMB4X\nDTIyMDIwODEzNDYwNVoXDTMyMDIwNjEzNDYwNVowPDELMAkGA1UEBhMCSU4xCzAJ\nBgNVBAgMAktBMQ4wDAYDVQQKDAVJSUlUQjEQMA4GA1UEAwwHUGFydG5lcjCCASIw\nDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALn5gSqZz2o9sKdtAnuGUlT28E2n\nPMfteIyMBRHxEMQqHC+eyIxUpFYvHYR50oONqCJ8lyytSRqaIQzIZyTtyWTw+3ft\ncW8rcy7za6sgIAcDkf9giEYGlEAQslGfa2xm9DZzUFzKID8ISBLuCTWEaDirrBU4\n6b13x/sIa3zpz3buOnT8B5IcsVsSLaT2obNuJ1UhE3AcUFF0F9WcLQfuGYnzXKqW\nDNfkxcKAGLoJ+RIlx/cXl5WYbwqoYl3wIpqxcJe/+JUf3lNFE3r5Q2+TcUizRDKZ\nZX7yy7H+0ZmEaI1vc6eGuLLE1LzJQDY52+W4LJGK4bnhv4mKgB88c3HSKv0CAwEA\nAaOBpjCBozAJBgNVHRMEAjAAMBEGCWCGSAGG+EIBAQQEAwIEEDAzBglghkgBhvhC\nAQ0EJhYkT3BlblNTTCBHZW5lcmF0ZWQgQ2xpZW50IENlcnRpZmljYXRlMB0GA1Ud\nDgQWBBTd0sTKXbC5CUNwIWIQDLQIRDPrpjAfBgNVHSMEGDAWgBT2NPSFlaT+Y1wO\nzyZOYdKH442EwjAOBgNVHQ8BAf8EBAMCBeAwDQYJKoZIhvcNAQELBQADggEBAEzs\nXqPyhPXU+Ko3s+XQ792jm/mppsAGV4cMLBC6tJECJajAFQGWII4FsEq/nlgjOlUv\nwtQoDEMZhF0DY4HNnru2CYrGmC4iNXCss6OZXpfnjwhWLWaCQOJRE1sIaYGxbz8d\n0dL7t77x2S5+cJLXGPel2HZVHvdKKIi7LoH6JFSyqHU6Iyzj0szYTnJdzBC9ELjC\n8IBwyETd0pQ1w8NE5cxe2jiM3neNO48s2fvpA6BcgUhmIJAIi953PBOdxqqM1b8D\nAQ7A5w8Zz+k61ncXVs0A6PWXKgogqJxTsZ+3X68Z/lTpy8wPz1/yPT80D4jF46wb\nxajUAmH5HcJ5uqAh1vI=\n-----END CERTIFICATE-----\n",
	    "partnerDomain": "Auth",
	    "partnerId": "mpartner-default-print"
	  },
	  "requesttime": "",
	  "version": "string"
	}

# Troubleshooting

- Please check if the domain name is correctly replaced.
- In case of errors related to timestamp please update the latest timestamp in the request.
- If the Swagger links are not available check if the services are running fine. 
	swagger 1:- kernel-Auth-service.
	swagger 2:- pms services.
	swagger 3:- pms services.
- For other descrepencies raise a github issue.
