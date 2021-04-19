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
	    "certificateData": "-----BEGIN CERTIFICATE-----\nMIIDFTCCAf2gAwIBAgIESXfzlDANBgkqhkiG9w0BAQsFADA7MQswCQYDVQQGEwJJ\nTjELMAkGA1UECBMCS0ExDTALBgNVBAoTBFRlc3QxEDAOBgNVBAMTB1JPT1QtQ0Ew\nHhcNMjAxMjE4MTM1NDM0WhcNMjMxMjE4MTM1NDM0WjA7MQswCQYDVQQGEwJJTjEL\nMAkGA1UECBMCS0ExDTALBgNVBAoTBFRlc3QxEDAOBgNVBAMTB1JPT1QtQ0EwggEi\nMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC8gwrXv+9PXyY4P4+6Kr2i5EYE\nycrqoBz0UrZYT+mIUl1JF7CFddujpy8ejF78RbgjZoCqcxmi31Abj6Sj6MPRlMXI\nXVWzE6DQPK2xHn+3it8es+QAHt2Z4zDJSICm2DI9qCQa95iTl/WbrQK4nHYeiSx3\nBOQuf05pNSiPcrBqP+xwxcPkNVIl0eRbs0Lnd37qWh9ZBIy3N4tJduneJGRwW1qs\nYvTTUxPBIlCBraqLq7o9uxMr9+kOv1wxesV8ZGOS3KFa4CQxOHywJ1secnMnca0e\ntQQcmSzckG+8QqKQQNbfFSRYkRkfOM4aHRDozmMMTdI0TA9eELZxFMXiTkjlAgMB\nAAGjITAfMB0GA1UdDgQWBBSKXY7NPI6uL5BhbICYl4wWQUdEOTANBgkqhkiG9w0B\nAQsFAAOCAQEAbk+qM7X1G0SRH/bHEu0Yntx2Lae+iYyrCLEHOgJ+ygQ4u/FzGjQQ\nJWGWZtqpehE0sN/CBB/xfz3FDAJdj7iNYD3H0fNRNywpQWQt1EzKkwJFxgJ16P7l\nq9DzZpz1EuFZC/eqbkFhQSqbRrBnLVzYgAc9RZnaqRS5TSF/J+Qj+uUYbcGeWBRN\nPVcPwM7Nx0sQLHosPYZt7YTytr2P9NVZgBGLre+aNECWeRh3hBIBZ52qSVDq/1Df\nW9sqNLTel9i0l5eNC9AuIf8TwSqGUUTkHqLI4lk5KoUfei15DDOPLOESqplYYezb\nY6Ujm9OwNYFSDuS2IMTAIxzheHt/XJnxMw==\n-----END CERTIFICATE-----",
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
	    "certificateData": "-----BEGIN CERTIFICATE-----\nMIIDPTCCAiWgAwIBAgIEBiaW/DANBgkqhkiG9w0BAQsFADA7MQswCQYDVQQGEwJJ\nTjELMAkGA1UECBMCS0ExDTALBgNVBAoTBFRlc3QxEDAOBgNVBAMTB1JPT1QtQ0Ew\nHhcNMjAxMjE4MTM1NjQwWhcNMjExMjE4MTM1NjQwWjBCMQswCQYDVQQGEwJJTjEL\nMAkGA1UECBMCS0ExDTALBgNVBAoTBFRlc3QxFzAVBgNVBAMTDlNpZ25lZC1QYXJ0\nbmVyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAstCVDizWIlcXj4EQ\nhFfoE3jd3MaDNjHXA5MC4PpwHuHnDl9EGrAKEXL2j7tdOQBBMu6VBLSDTnG2jInT\ne33Ou/yNLQX6/47FXZnRmPQ7ZqUL4ETp+bSBah9spQVQ9Uh7jxfWBeq9pA1xHrLh\nkDm0JCIYKQxqupnZZFdl4M7QmhKtpMct5KkwU5a4J+6an0uSX+ZdGr0lB/mtKEyh\n2wJlJG7THKMCbrODLH3Fhw+1Gz0e9qYF+tvM7T8tQGAUzeXc7Mr/+vE1RsC3IzQf\nwbjO19b2GLYEHLXNKbYYr3c9H+/GaaWJArMDmp+MNG8M0J/JPlxhsUi5mD/y4fFP\n4VWEsQIDAQABo0IwQDAdBgNVHQ4EFgQUQuT6c0WImkDDnQHTK0gx3DRjvBswHwYD\nVR0jBBgwFoAUil2OzTyOri+QYWyAmJeMFkFHRDkwDQYJKoZIhvcNAQELBQADggEB\nAAyLGiqdH6gTXgjDbngmdNbNuusTeflVaqdWtteIBgXvn01aigK/9eQqAGsQH6SO\nICae+GCmTTAWF5wkZbecPSravndzMNNtCVbhq32+liQHkNIzZCsc0Ous+Ifr+zOE\nJ1nc/3/Wrx5q2OH7A0IvE/wIBi1KHLxcDdkXL6E27TUiXvT3tgITtpVKq5UPcpag\nHnf80AVZ/6CA+kbTxgsXg+0ScVCy1lCuw25HdMhEr4MS3vGEPfv5yttLz7ImNY1L\nMIAyRu4DzDctAebecNOVIL6Jp3o4MCl458p/kVqKluGMW3A9c0+iim1wlmwhWTin\nptNsenIRS+hBPLYHJZ6sz4I=\n-----END CERTIFICATE-----",
	    "partnerDomain": "Auth",
	    "partnerId": "mpartner-default-prnt"
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
