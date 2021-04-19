# IDA certificate exchange guide 

- In Ida we have two types of certificate exchange
	- IDA Zero knowledge certificate exchange this is taken care just after the ida installaton is done in playbook ```ida.yml```
	- IDA mpartner-default-auth partner certificate exchange :- for this we need to follow the below steps:-

  * 1. Authenticate yourself and get authorization token from authmanager swagger. Also adding the request after that which can be used.. please update the domain name in the request.

	SWAGGER URL:- ```https://minibox.mosip.net/v1/authmanager/swagger-ui.html#/authmanager/clientIdSecretKeyUsingPOST ```  hit authmanager section in try-out section.
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
  * 2. Get the ROOT certificate data from the below URL, Copy it and use it for certificate exchange in the next step.
	```https://minibox.mosip.net/idauthentication/v1/internal/getCertificate?applicationId=ROOT```

  * 3. Upload ROOT certificate from the above request in the below SWAGGER URL:- ```https://minibox.mosip.net/v1/partnermanager/swagger-ui.html#/Partner%20Service%20Controller/uploadCACertificateUsingPOST``` Partner_Service_Controller --> /partners/certificate/ca/upload --> with below request
	```
	{
	  "id": "string",
	  "metadata": {},
	  "request": {
	    "certificateData": "-----BEGIN CERTIFICATE-----\nMIIDTjCCAjagAwIBAgIEYFrxXTANBgkqhkiG9w0BAQsFADBpMQswCQYDVQQGEwJJ\nTjESMBAGA1UECAwJS2FybmF0YWthMRIwEAYDVQQHDAlCYW5nYWxvcmUxHjAcBgNV\nBAoMFW1wYXJ0bmVyLWRlZmF1bHQtYWJpczESMBAGA1UEAwwJYWJpcy1yb290MB4X\nDTIxMDMyNDA3NTkyNVoXDTIyMDMyNDA3NTkyNVowaTELMAkGA1UEBhMCSU4xEjAQ\nBgNVBAgMCUthcm5hdGFrYTESMBAGA1UEBwwJQmFuZ2Fsb3JlMR4wHAYDVQQKDBVt\ncGFydG5lci1kZWZhdWx0LWFiaXMxEjAQBgNVBAMMCWFiaXMtcm9vdDCCASIwDQYJ\nKoZIhvcNAQEBBQADggEPADCCAQoCggEBANkwlDzNZTBi1fBF4GU4qFAJ3S+Ca0Kf\ngfvg93rQlZ5LBTnZFwAxpCZtGHYb7vkqM9e7adYGC48EPWI0A+48QmF3Z6vSBXg9\nKckINa/vFCTEYrctMHS8CcBjWBf9agJq4+wWqNu8sYHD9pOzDf1uMbQJTI5VvgGx\nv890pZrXdIrR4MPTLB0rkl2sVOqbG7bts0Eqh8TO86126CDzoDrtBCj3RBP/j/dg\nBmz7LWFkG6/by+mXzdZcS46v7P/Q366WrDbMCCtjKIRAA0HQD3vdKT0V03Eiw/EU\nVxVh9sdbkO5h/T8VWI7ghEjr4PpJXPYWRbVlt6uPDpbX+yEiOWG/SsMCAwEAATAN\nBgkqhkiG9w0BAQsFAAOCAQEAEj42FlN8LnNPv3iWttydxm9kEJemyJdw8nPLCC4y\nxigXrcxPgNcoJiDBXLIAwhTmPK1hdn/BndAeUsX8mauuzf4V7Ydw1a999s8Vsj8S\nOLa8voXAE2sjdYZm0cYID0y/ak3+ZrKqCXP6bcmPOLz2plnGJB7TUQ+d8gZXsLA6\nCoopaJOlNM4jPNbX/k30vfFmyrXm2++5stErrSOix25J79DGdmJH896/pmGmB60/\nXGnpyESrVTbhTE+cx0gDHdq5T47qHcXM6CVuH/uYNy5iLCaBRzVQ043gFj3ioym1\nnZ60dsvdG8nEENBu9SzN3Mn24pz0BQ99Qn5ymsQwYAEeDQ==\n-----END CERTIFICATE-----\n",
	    "partnerDomain": "AUTH"
	  },
	  "requesttime": "2021-03-24T08:24:13.349Z",
	  "version": "string"
	}
	```
  * 4. Get the IDA certificate data from the below URL, Copy it and use it for certificate exchange in the next step.
        ```https://minibox.mosip.net/idauthentication/v1/internal/getCertificate?applicationId=IDA```

  * 5. Upload IDA certificate from the above request in the below SWAGGER URL:- ```https://minibox.mosip.net/v1/partnermanager/swagger-ui.html#/Partner%20Service%20Controller/uploadCACertificat$        ```
        {
          "id": "string",
          "metadata": {},
          "request": {
            "certificateData": "-----BEGIN CERTIFICATE-----\nMIIDTjCCAjagAwIBAgIEYFrxXTANBgkqhkiG9w0BAQsFADBpMQswCQYDVQQGEwJJ\nTjESMBAGA1UECAwJS2FybmF0YWthMRIwEAYDVQQHDA$
            "partnerDomain": "AUTH"
          },
          "requesttime": "2021-03-24T08:24:13.349Z",
          "version": "string"
        }
        ```
  * 6. Get the mpartner-default-auth partner certificate data from the below URL, Copy it and use it for certificate exchange in the next step.
        ```https://minibox.mosip.net/idauthentication/v1/internal/getCertificate?applicationId=IDA&referenceId=mpartner-default-auth```


  * 7. Upload mpartner-default-auth Partner certificate in the below SWAGGER URL:- ```https://minibox.mosip.net/v1/partnermanager/swagger-ui.html#/Partner%20Service%20Controller/uploadPartnerCertificateUsingPOST_1``` Partner_Service_Controller --> /partners/certificate/upload --> with below request
	```
	{
	  "id": "string",
	  "metadata": {},
	  "request": {
	    "certificateData": "-----BEGIN CERTIFICATE-----\nMIIDWjCCAkKgAwIBAgIEYFrz6DANBgkqhkiG9w0BAQsFADBpMQswCQYDVQQGEwJJ\nTjESMBAGA1UECAwJS2FybmF0YWthMRIwEAYDVQQHDAlCYW5nYWxvcmUxHjAcBgNV\nBAoMFW1wYXJ0bmVyLWRlZmF1bHQtYWJpczESMBAGA1UEAwwJYWJpcy1yb290MB4X\nDTIxMDMyNDA4MTAxNloXDTIyMDMyNDA4MTAxNlowdTELMAkGA1UEBhMCSU4xEjAQ\nBgNVBAgMCUthcm5hdGFrYTESMBAGA1UEBwwJQmFuZ2Fsb3JlMR4wHAYDVQQKDBVt\ncGFydG5lci1kZWZhdWx0LWFiaXMxHjAcBgNVBAMMFW1wYXJ0bmVyLWRlZmF1bHQt\nYWJpczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKuA8CuDIRQCUCl9\nyVh/dGOb/CiMnbcL/lsLq+VeYo51yyycj5kH2wuTlnXRZAOJklCvhAIJP68q799S\nW+aMr+pOLm4rCgMfPD30UVdcmza+dPfl7A3/YZ5UjALOqjVMmwcUxmh1k5yL9QRo\n1LNLCGkwd0hfgT35Y9sC0CDxD3aOesaz0oP9dkGETpcv8nMW4VxWHvOekup1gqAi\nEn1VBat6qVGjwBNKAVkq75Q8P477DyT+t9NRs9IW68ZQXvR+VQvofDNDk8PshXVQ\nMjesEgQHs7bIhTb6hAmGJsQM97yBAA6+EEGGqvLTZDDXjTAtdNZpjml0jaaMnURl\nzF+qh08CAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAjdfHjKlrt7mV0MomYO7KkuCc\naCscPAN74UZaCMRE5pXixeQVctsWE/KI7KdmJwZWqZvQrb/AX4VwZu5A1zcDNOJ6\nB7UaDePCMBXRPcyUAAWWwr0AtV0JkEei3d2TbqiPXqlCM1fvvkKQqGZxa61CvSdN\nz2XmY9W09gbAgkMx3svv6MHpZlJuWY8OZVr0ID1hW+ajEoCf5Adv2Iwuogg/Hs9D\nlhhvYg4GzU/qWE9vFYO52UqtVPfrzQZTPBQE5Hrg0a32HBOwL3vu0ms2gf1lEt23\nEf/8TZA5kT/0bMYlB6heGjIKEC90tEv645jbkgJoCI+GgazTTe9wYHXmgz9oPw==\n-----END CERTIFICATE-----\n",
	   "partnerDomain": "Auth",
	    "partnerId": "mpartner-default-auth"
	    },
	  "requesttime": "",
	  "version": "string"
	}

  * 8. Upload the response signinng certificate obtained from the reponse of the above api into the keymanager for mpartner-default-ida partner in keymanager using below Swagger URL: `https://minibox.mosip.net/idauthentication/v1/internal/swagger-ui.html#/keymanager/uploadCertificateUsingPOST`  keymanager --> /uploadCertificate with below request
	```
	{
	  "id": "string",
	  "metadata": {},
	  "request": {
	    "applicationId": "PARTNER",
	    "certificateData": "certficate data fom the responce of step 7",
	    "referenceId": "mpartner-dafault-auth"
	  },
	  "requesttime": "2018-12-10T06:12:52.994Z",
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
	get certificate request :- ida services.
- In case you gett error in certifacte upload for either of ROOT, IDA, mpartner-default-auth reponse as ```certificate data already exist``` pls ignore as the certifcate exchange is done once.
- As of now this is WIP on this document. 
- For other descrepencies raise a github issue.
- Below is the example of how to get the get the certificate data from the response.
        ```
	{"id":null,"version":null,"responsetime":"2021-04-18T10:03:20.606Z","metadata":null,"response":{"certificate":"~~~-----BEGIN CERTIFICATE-----\nMIIDkDCCAnigAwIBAgIIzui2vr6fKUMwDQYJKoZIhvcNAQELBQAwbjELMAkGA1UE\nBhMCSU4xCzAJBgNVBAgMAktBMRIwEAYDVQQHDAlCQU5HQUxPUkUxDTALBgNVBAoM\nBElJVEIxGjAYBgNVBAsMEU1PU0lQLVRFQ0gtQ0VOVEVSMRMwEQYDVQQDDApNT1NJ\nUC1ST09UMB4XDTIwMTIxNTE1NDcxOVoXDTI1MTIxNTE1NDcxOVowbjELMAkGA1UE\nBhMCSU4xCzAJBgNVBAgMAktBMRIwEAYDVQQHDAlCQU5HQUxPUkUxDTALBgNVBAoM\nBElJVEIxGjAYBgNVBAsMEU1PU0lQLVRFQ0gtQ0VOVEVSMRMwEQYDVQQDDApNT1NJ\nUC1ST09UMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0IG5QpRMA1dZ\n2FRitMuNlzOCr+qsEZnFGdUH6npYMgNPSw7kJAHpo2CAo4WBNAgz6i1fASSqb8EZ\nXmxnKC9qW31zf8xmnwJNDMFIYctZTp1ZVG7yox+HeI4u//XymAGEg0U/bJ9FVpYr\n6TIbFIO7HzbB12qEwEmvniWKILqzf7qY6F+62GrJyFIwdpWkmlDMUdU4L9V3R10S\nwrNOTDkbHnLb34uwtBpaMHmYgOasaOXxCNcEzdOf56w6RTJmSla9TJgeXn0hikF1\ntxlHkv3Bw2T4y7eVL7NZeMhKkJJW0J4+hWm6nWzRG3Su31HoUIph1GFhrVrq/84B\nlOqHvpDIcwIDAQABozIwMDAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBS+Kdh1\nX3eiq7UDZ3jBJwoKzFjLaDANBgkqhkiG9w0BAQsFAAOCAQEASzHHVt79eqzzYKLi\ncquGoS31Flq+EKrUdm5zLIYQx9lolVmRveJEqE85x02dGu8MMWjsshQvnzbG0PET\nR5kED5tVRSYx1W/Da5uE7EzQpiYeKsakmSArnslB0kFB+8UGb3KlmCUrQC0C4Ufo\ngbl2zEj9slLgjHKYbvGlki3Sz0oFAdEjuBdbWOrOaMQMUu7OZjMl/scyMBAR0U5J\nURVAGbEniMrw7a1z3LynVerc1qDAbuX1l4njUnit+JbB9B7QPbTEKjce1/pdyvUc\n9SbJpoznaFTRNFyq1iI98hsk+Iu9AImohiCV2DsvVULzACVQXhdApbVZBqjHAHbn\nkQcdtw==\n-----END CERTIFICATE-----\n~~~","certSignRequest":null,"issuedAt":"2020-12-15T15:47:19.000Z","expiryAt":"2025-12-15T15:47:19.000Z","timestamp":"2021-04-18T10:03:20.606Z"},"errors":[]}
	``` 
	highlighted data between three tildas - ~~~ ~~~ in the above response is the example certificate data required.
