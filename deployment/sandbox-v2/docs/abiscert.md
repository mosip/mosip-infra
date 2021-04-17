# Abis certificate exchange guide so that it will be able to decrypt the packets

* Below are the steps which needed to be followed for abis certificate exchange once after the depoloyment is done.

- Authenticate yourself and get authorization token from authmanager swagger. Also adding the request after that which can be used.. please update the domain name in the request.

  * 1. SWAGGER URL:- ```https://minibox.mosip.net/v1/authmanager/swagger-ui.html#/authmanager/clientIdSecretKeyUsingPOST ```  hit authmanager section in try-out section.
	```
	{
	  "id": "string",
	  "metadata": {},
	  "request": {
	    "appId": "regproc",
	    "clientId": "mosip-regproc-client",
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
	    "certificateData": "-----BEGIN CERTIFICATE-----\nMIIDTjCCAjagAwIBAgIEYFrxXTANBgkqhkiG9w0BAQsFADBpMQswCQYDVQQGEwJJ\nTjESMBAGA1UECAwJS2FybmF0YWthMRIwEAYDVQQHDAlCYW5nYWxvcmUxHjAcBgNV\nBAoMFW1wYXJ0bmVyLWRlZmF1bHQtYWJpczESMBAGA1UEAwwJYWJpcy1yb290MB4X\nDTIxMDMyNDA3NTkyNVoXDTIyMDMyNDA3NTkyNVowaTELMAkGA1UEBhMCSU4xEjAQ\nBgNVBAgMCUthcm5hdGFrYTESMBAGA1UEBwwJQmFuZ2Fsb3JlMR4wHAYDVQQKDBVt\ncGFydG5lci1kZWZhdWx0LWFiaXMxEjAQBgNVBAMMCWFiaXMtcm9vdDCCASIwDQYJ\nKoZIhvcNAQEBBQADggEPADCCAQoCggEBANkwlDzNZTBi1fBF4GU4qFAJ3S+Ca0Kf\ngfvg93rQlZ5LBTnZFwAxpCZtGHYb7vkqM9e7adYGC48EPWI0A+48QmF3Z6vSBXg9\nKckINa/vFCTEYrctMHS8CcBjWBf9agJq4+wWqNu8sYHD9pOzDf1uMbQJTI5VvgGx\nv890pZrXdIrR4MPTLB0rkl2sVOqbG7bts0Eqh8TO86126CDzoDrtBCj3RBP/j/dg\nBmz7LWFkG6/by+mXzdZcS46v7P/Q366WrDbMCCtjKIRAA0HQD3vdKT0V03Eiw/EU\nVxVh9sdbkO5h/T8VWI7ghEjr4PpJXPYWRbVlt6uPDpbX+yEiOWG/SsMCAwEAATAN\nBgkqhkiG9w0BAQsFAAOCAQEAEj42FlN8LnNPv3iWttydxm9kEJemyJdw8nPLCC4y\nxigXrcxPgNcoJiDBXLIAwhTmPK1hdn/BndAeUsX8mauuzf4V7Ydw1a999s8Vsj8S\nOLa8voXAE2sjdYZm0cYID0y/ak3+ZrKqCXP6bcmPOLz2plnGJB7TUQ+d8gZXsLA6\nCoopaJOlNM4jPNbX/k30vfFmyrXm2++5stErrSOix25J79DGdmJH896/pmGmB60/\nXGnpyESrVTbhTE+cx0gDHdq5T47qHcXM6CVuH/uYNy5iLCaBRzVQ043gFj3ioym1\nnZ60dsvdG8nEENBu9SzN3Mn24pz0BQ99Qn5ymsQwYAEeDQ==\n-----END CERTIFICATE-----\n",
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
	    "certificateData": "-----BEGIN CERTIFICATE-----\nMIIDWjCCAkKgAwIBAgIEYFrz6DANBgkqhkiG9w0BAQsFADBpMQswCQYDVQQGEwJJ\nTjESMBAGA1UECAwJS2FybmF0YWthMRIwEAYDVQQHDAlCYW5nYWxvcmUxHjAcBgNV\nBAoMFW1wYXJ0bmVyLWRlZmF1bHQtYWJpczESMBAGA1UEAwwJYWJpcy1yb290MB4X\nDTIxMDMyNDA4MTAxNloXDTIyMDMyNDA4MTAxNlowdTELMAkGA1UEBhMCSU4xEjAQ\nBgNVBAgMCUthcm5hdGFrYTESMBAGA1UEBwwJQmFuZ2Fsb3JlMR4wHAYDVQQKDBVt\ncGFydG5lci1kZWZhdWx0LWFiaXMxHjAcBgNVBAMMFW1wYXJ0bmVyLWRlZmF1bHQt\nYWJpczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKuA8CuDIRQCUCl9\nyVh/dGOb/CiMnbcL/lsLq+VeYo51yyycj5kH2wuTlnXRZAOJklCvhAIJP68q799S\nW+aMr+pOLm4rCgMfPD30UVdcmza+dPfl7A3/YZ5UjALOqjVMmwcUxmh1k5yL9QRo\n1LNLCGkwd0hfgT35Y9sC0CDxD3aOesaz0oP9dkGETpcv8nMW4VxWHvOekup1gqAi\nEn1VBat6qVGjwBNKAVkq75Q8P477DyT+t9NRs9IW68ZQXvR+VQvofDNDk8PshXVQ\nMjesEgQHs7bIhTb6hAmGJsQM97yBAA6+EEGGqvLTZDDXjTAtdNZpjml0jaaMnURl\nzF+qh08CAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAjdfHjKlrt7mV0MomYO7KkuCc\naCscPAN74UZaCMRE5pXixeQVctsWE/KI7KdmJwZWqZvQrb/AX4VwZu5A1zcDNOJ6\nB7UaDePCMBXRPcyUAAWWwr0AtV0JkEei3d2TbqiPXqlCM1fvvkKQqGZxa61CvSdN\nz2XmY9W09gbAgkMx3svv6MHpZlJuWY8OZVr0ID1hW+ajEoCf5Adv2Iwuogg/Hs9D\nlhhvYg4GzU/qWE9vFYO52UqtVPfrzQZTPBQE5Hrg0a32HBOwL3vu0ms2gf1lEt23\nEf/8TZA5kT/0bMYlB6heGjIKEC90tEv645jbkgJoCI+GgazTTe9wYHXmgz9oPw==\n-----END CERTIFICATE-----\n",
	    "organizationName": "mpartner-default-abis",
	    "partnerDomain": "Auth",
	    "partnerId": "mpartner-default-abis",
	    "partnerType": "ABIS_Partner"
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
