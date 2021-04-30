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
	    "certificateData": "-----BEGIN CERTIFICATE-----\nMIIDFTCCAf2gAwIBAgIEG6DiGjANBgkqhkiG9w0BAQsFADA7MQswCQYDVQQGEwJJ\nTjELMAkGA1UECBMCS0ExDTALBgNVBAoTBElJVEIxEDAOBgNVBAMTB1JPT1QtQ0Ew\nHhcNMjEwMzE2MTIyNTIxWhcNMjQwMzE1MTIyNTIxWjA7MQswCQYDVQQGEwJJTjEL\nMAkGA1UECBMCS0ExDTALBgNVBAoTBElJVEIxEDAOBgNVBAMTB1JPT1QtQ0EwggEi\nMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC5CXtlh1auztC/rDJDzNojowau\ny+etRWmlAFtnXllV287MWdYIg4hGOaPA3QAqcwxj1JdV7OX57SkWse33uWiCfkoi\n9HmOpXrJTsMxrGWUnW1Fs+ZhNLrQbtX8K4kODtrDeqov8ylOxVixeSVDwMXho/+D\nvH7UjYH4o3ch4LkObXC/4sogeHsYTTK+UDpwPmBsYFAu3b+dzTPP+LEmXcb0Gd3Q\nCEdOUdebJchrk4ap+1BJWAVGN0yFedJmj/Rtv3PNhecc37oKn9iN+zjPhetLKKnq\n2CKaim4NKH3YiNhE+QgRyBhW9tmw9l38YNQDxMo74DShr1gb8PXv/MffToJzAgMB\nAAGjITAfMB0GA1UdDgQWBBT/ESM8XxLIsUs1bHaPj3tjMo3rzzANBgkqhkiG9w0B\nAQsFAAOCAQEAUutt5AL/I0UpG0FfVF9dsZAMlRYRqWxCYlhOPKrInfEZAGQUez85\nHHOlD0saYpypvIx9h8zH4ndotnalloGs1/rKuze/MiPdIRKu7ltcNe+OwQNd5dqB\nhfzC5RLJnpShcmjq7w6eq3RfQMiDgMenLqlY1a+1mVMWB00ha/EcqbwizkuSr/AM\nbB/GlOTmWQFyUEGHN536ALnX7zs+56kVm3BUzK+qcSfCD20v815HXEl8DoRgxoPD\nwxJviKzXwb19qabhMGOGD3lqr2pByxqnJF/fgyoeH8GqoH3pLEmwlrMVc8yYP0Rc\nZYSu5nQaIN2ZCvEDpdD3ieUpE653CfRFPQ==\n-----END CERTIFICATE-----",
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
	    "certificateData": "-----BEGIN CERTIFICATE-----\nMIIDPTCCAiWgAwIBAgIEWUs5tjANBgkqhkiG9w0BAQsFADA7MQswCQYDVQQGEwJJ\nTjELMAkGA1UECBMCS0ExDTALBgNVBAoTBElJVEIxEDAOBgNVBAMTB1JPT1QtQ0Ew\nHhcNMjEwMzE2MTIyNzM4WhcNMjIwMzE2MTIyNzM4WjBCMQswCQYDVQQGEwJJTjEL\nMAkGA1UECBMCS0ExDTALBgNVBAoTBElJVEIxFzAVBgNVBAMTDlNpZ25lZC1QYXJ0\nbmVyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6LVFKcOPnadipOOZ\nVgA8nhaJos8CUGTqwjk4AF6gK3SY5f6W+wcuQR2SM8Q4K0MC1P5HLjdvXgYyoUAW\nfAid98P15AdqihP9cM1ZhB+zGqyZc3nmfjJ4sstRRgbhEfgLI41uYEPaO6GXnZkN\ndhSf5343VoNwQTTI1gpoc8XqT7w4naqaA4H+KR31a6lhnpUCoUHtfZxH+5cRXSv8\n7Ul/qTCO9HG1zM3PIrVnod8e610AbPKJXf9RAMeZsnbXWm5EIilzwUJaleP6Bsbx\np+9aTgImi4LA484eaS4AS9FExil/zWQrXr0Prox8u/Eenjt65Rt0iXwq0V0dJu6I\nHNLRhQIDAQABo0IwQDAdBgNVHQ4EFgQUvv1XjfOlkamCtykSyo7uowL4OeswHwYD\nVR0jBBgwFoAU/xEjPF8SyLFLNWx2j497YzKN688wDQYJKoZIhvcNAQELBQADggEB\nAEl6BGIP2agU3fGBVGP+Hp1ANROa9A3tBCTo3Uggw+YoVqwuod852Da6K531owQh\nyHWKt8VTVOVl/la/YyKDasgyuJ4pvSruN8YMgJBVPu7iIpBpfVrG7pE9//bzER+X\nqB1StxLa0f05ZFFU5iWOixG14a/YYsqhauOtTtzwuMXHYyrtdCFx8VZRjqM40myw\nhq7EvBxv/pbnaLKs8YUipSV1HNyvb8xej/Gx0abGMQHB3hJ/kNVilKx7ntkx33cJ\nEHSlF+YbhEmc1mNG6D5Pr/l1YVOxOAH4Fa/fMDtGtTOuIKEDHwOJIvFNId4SPdJE\nq26q8M+7WyNPU1l77eDPVzc=\n-----END CERTIFICATE-----",
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
