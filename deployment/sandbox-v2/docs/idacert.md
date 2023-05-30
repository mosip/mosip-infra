# IDA certificate exchange guide 

- In IDA, there are two kinds of certificate exchange.
  
	  1 . IDA Zero-knowledge certificate exchange

	  2 . IDA mpartner-default-auth partner certificate exchange. 


  For IDA Zero-Knowledge certificate exchange,below are the steps 
  * 1. Authenticate yourself and get authorization token from authmanager swagger

	SWAGGER URL:- ```https://minibox.mosip.net/v1/authmanager/swagger-ui.html#/authmanager/clientIdSecretKeyUsingPOST ``` 
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
  * 2. Get the certificate data from the URL mentioned below. The application id(appId) used is IDA and reference id(refId)= CRED_SERVICE
	```https://minibox.mosip.net/idauthentication/v1/internal/swagger-ui/index.html?configUrl=/idauthentication/v1/internal/v3/api-docs/swagger-config#/keymanager/getCertificate```
     
       Ensure to copy the certificate value in the response from the above request.
       
  * 3. Upload the copied certificate from step-2 through the below SWAGGER URL:-
       
       ```https://minibox.mosip.net/v1/keymanager/swagger-ui/index.html?configUrl=/v1/keymanager/v3/api-docs/swagger-config#/keymanager/uploadOtherDomainCertificate``` 
      
       Request body:
	```
	{
     "id": "string",
     "version": "string",
     "requesttime": "2023-05-30T04:36:36.006Z"
     "metadata": {},
     "request": {
     "applicationId": "IDA",
     "referenceId": "PUBLIC_KEY",
     "certificateData": "{copied certificate from step-II}" }}

 P.S : The process of uploading IDA Zero-Knowledge certificates should only take place once per environment.
 
For IDA mpartner-default-auth partner certificate exchange, below are the steps
      
   * 1. Authenticate yourself and get authorization token from authmanager swagger
      SWAGGER URL:- ```https://minibox.mosip.net/v1/authmanager/swagger-ui.html#/authmanager/clientIdSecretKeyUsingPOST ```
      
       
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
	


  * 2. Get the ROOT certificate data from the below URL.
       
        ```https://minibox.mosip.net/idauthentication/v1/internal/getCertificate?applicationId=ROOT```

       Ensure to copy the certificate value in the response from the above request.

  * 3. Upload copied ROOT certificate through the below SWAGGER URL:-
       
        ```https://minibox.mosip.net/v1/partnermanager/swagger-ui.html#/Partner%20Service%20Controller/uploadCACertificateUsingPOST ```
       ```{
          "id": "string",
          "metadata": {},
          "request": {
            "certificateData": "{Copied certificate from step-II}"
            "partnerDomain": "AUTH"
          },
          "requesttime": "2021-03-24T08:24:13.349Z",
          "version": "string"
        }
	
  * 4. Get the IDA certificate data from the below URL
      
      ```https://minibox.mosip.net/idauthentication/v1/internal/getCertificate?applicationId=IDA ```
      

     make sure to copy the certificate value in the response from the above request. Save this copy as IDA.cer file locally as this might be required in the future.
  * 5. Upload copied IDA certificate from the above request in the below SWAGGER URL :-

    ```https://minibox.mosip.net/v1/partnermanager/swagger-ui.html#/Partner%20Service%20Controller/uploadCACertificateUsingPOST ```
      
        ```{
          "id": "string",
          "metadata": {},
          "request": {
            "certificateData": "{Copied certificate from step-IV}"
            "partnerDomain": "AUTH"
          },
          "requesttime": "2021-03-24T08:24:13.349Z",
          "version": "string"
        }
    
  * 6. Get the mpartner-default-auth partner certificate data from the below URL.

        ```https://minibox.mosip.net/idauthentication/v1/internal/getCertificate?applicationId=IDA&referenceId=mpartner-default-auth ```
       
Ensure to copy the certificate value in the response from the above request

  * 7. Upload mpartner-default-auth Partner certificate in the below SWAGGER URL:-
      
       ```https://minibox.mosip.net/v1/partnermanager/swagger-ui.html#/Partner%20Service%20Controller/uploadPartnerCertificateUsingPOST_1``` Partner_Service_Controller --> /partners/certificate/upload --> with below request
    ```
    {
      "id": "string",
      "metadata": {},
      "request": {
        "certificateData": "{Copied certificate from step-VI}",
       "partnerDomain": "AUTH",
        "partnerId": "mpartner-default-auth"
        },
      "requesttime": "",
      "version": "string"
    }
    ```

    Ensure to copy certificate value in the response. This is  MOSIP's pms-signed certificate.

  * 8. Upload copied pms-signed certificate through below URL:

       ``` https://api-internal.dev.mosip.net/idauthentication/v1/internal/swagger-ui/index.html?configUrl=/idauthentication/v1/internal/v3/api-docs/swagger-config#/keymanager/uploadCertificate  ```
       
   ```
    {
      "id": "string",
      "metadata": {},
      "request": {
        "applicationId": "PARTNER",
        "referenceId": "mpartner-default-auth",
        "certificateData": "Copied certficate data fom the responce of step VII(mosip-signed)"
      },
      "requesttime": "2018-12-10T06:12:52.994Z",
      "version": "string"
    }
    ```


## Troubleshooting

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
	

