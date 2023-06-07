# IDA certificate exchange guide 

- In IDA, there are two steps of certificate exchange :
  
  Step 1: IDA Zero-knowledge certificate exchange
  
  Step 2: IDA mpartner-default-auth partner certificate exchange

 `Step-1:`

  For IDA Zero-Knowledge certificate exchange, below are the steps: 
  
 * 1. Authenticate yourself and get authorization token from authmanager Swagger.

	Swagger URL:- ```https://minibox.mosip.net/v1/authmanager/swagger-ui.html#/authmanager/clientIdSecretKeyUsingPOST ``` 
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
  * 2. Get the certificate data from the URL mentioned below. Use application ID (appID) =IDA and reference ID (refID) =CRED_SERVICE
	```https://minibox.mosip.net/idauthentication/v1/internal/swagger-ui/index.html?configUrl=/idauthentication/v1/internal/v3/api-docs/swagger-config#/keymanager/getCertificate```
     
       Ensure to copy the certificate value in the response from the above request.
       
  * 3. Upload the copied certificate from step-II through the below Swagger URL.
       
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

 Note: The process of uploading IDA Zero-Knowledge certificates should only take place once.
 
`Step-2:`

For IDA mpartner-default-auth partner certificate exchange, below are the steps:
      
   * 1. Authenticate yourself and get authorization token from authmanager Swagger.
      Swagger URL:- ```https://minibox.mosip.net/v1/authmanager/swagger-ui.html#/authmanager/clientIdSecretKeyUsingPOST ```
      
       
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
	


  * 2. Get the CA certificate from the below URL.
       
        ```https://minibox.mosip.net/idauthentication/v1/internal/getCertificate?applicationId=ROOT```
    
    Sample Response :
 
   `` {
    "id": null,
    "version": null,
    "responsetime": "2023-06-06T04:14:53.267Z",
    "metadata": null,
    "response": {
    "certificate": "-----BEGIN CERTIFICATE-----\nMIIDlDCCAnygAwIBAgII4fC0eIinexgwDQYJKoZIhvcNAQELBQAwcDELMAkGA1UE\nBhMCSU4xCzAJBgNVBAgMAktBMRIwEAYDVQQHDAlCQU5HQUxPUkUxDTALBgNVBAoM\nBElJVEIxGjAYBgNVBAsMEU1PU0lQLVRFQ0gtQ0VOVEVSMRUwEwYDVQQDDAx3d3cu\nbW9zaXAuaW8wHhcNMjMwNTAyMDUwMzMxWhcNMjgwNTAxMDUwMzMxWjBwMQswCQYD\nVQQGEwJJTjELMAkGA1UECAwCS0ExEjAQBgNVBAcMCUJBTkdBTE9SRTENMAsGA1UE\nCgwESUlUQjEaMBgGA1UECwwRTU9TSVAtVEVDSC1DRU5URVIxFTATBgNVBAMMDHd3\ndy5tb3NpcC5pbzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALqDlR/1\n3ak4IMyszlXK/1r/EO3+FJUDAJmHh7ldqgARbIvqFaggvK1+mkbKHhEg5lkwIYfQ\n2JqcyHoOfH++HKd9Rz3UgDWjTs+FYvsnZvTXLAS8/K46heuhrDVh62RfEsxT+6Hw\nH9/rwhO389vv4sUnib9jhK7phoPWeQvcPCs/WWenwqDmXLgtaFZVpCpMwQddMjcb\nkO7mG7lHwztHTF8YMfAaD6qdKRoKlkAL6hROI2wgjVtGq0hhKsT5r5ErDpYmrQhl\nJkF/rDR4dy5fobG9/cPW92yBSNmQFzPkFRBgGKaat0an5xHA8LZi3DKKf9ZNorWR\ndzuUqOsBMQTUFVUCAwEAAaMyMDAwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQU\nUaI4d+3c/UFCyK27DMTOZdp4VOswDQYJKoZIhvcNAQELBQADggEBAIe68CCK+5Ff\nFghp9Rub3RmTtPkGDDfCyhCaV4BabKMPTfYHceIcHIrVHmFUhIhp++rHV0k+NF65\nP5Qzz8cccurv7kAWSF1QUJbKah0h28N5Et1wOylEGjASpdEb1QBRsBt2Lw2Ov6za\n/BEISOTnDhhCWEzAJBiDzjhBUIOo579QI34j6ZKpl1J4oDuOvqJYEyvOGigZegO5\nNdoYzfc8YAKaAlxQl1yQDGPVWjZL3f3af9NpsioovjiPq1xQZuBKnFhlt2oRIEmF\nScctUgo/35i+fLSvmU/fz0edmv8BrKEoD98xZaHsuHHELsT5q/c+6YM7FtgM1XPj\nxng33ECpswo=\n-----END CERTIFICATE-----\n",
    "certSignRequest": null,
    "issuedAt": "2023-05-02T05:03:31.000Z",
    "expiryAt": "2028-05-01T05:03:31.000Z",
    "timestamp": "2023-06-06T04:14:53.308Z"
    },
    "errors": []
    }
   ``
       Ensure to copy the certificate value in the response from the above request.

  * 3. Upload copied ROOT certificate through the below Swagger URL.
       
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
	```
	
  * 4. Get the SUBCA certificate data from the below URL.
      
      ```https://minibox.mosip.net/idauthentication/v1/internal/getCertificate?applicationId=IDA ```
      

     Ensure to copy the certificate value in the response from the above request. 
     
     
  * 5. Upload copied IDA certificate from the above request in the below Swagger URL.

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
    
  * 6. Get the mpartner-default-auth partner(Partner Certificate /Client certificate ) certificate data from the below URL.

        ```https://minibox.mosip.net/idauthentication/v1/internal/getCertificate?applicationId=IDA&referenceId=mpartner-default-auth ```
       
Ensure to copy the certificate value in the response from the above request. Save this copy as `mpartner-default-auth.cer` file locally as this may be used in the future.

  * 7. Upload mpartner-default-auth Partner certificate in the below Swagger URL:
      
       ```https://minibox.mosip.net/v1/partnermanager/swagger-ui.html#/Partner%20Service%20Controller/uploadPartnerCertificateUsingPOST_1``` 
 `
 
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
`
    Ensure to copy certificate value in the response. This is  MOSIP's pms-signed certificate.

  * 8. Upload copied pms-signed certificate through below URL:

       ``` https://api-internal.dev.mosip.net/idauthentication/v1/internal/swagger-ui/index.html?configUrl=/idauthentication/v1/internal/v3/api-docs/swagger-config#/keymanager/uploadCertificate  ```
       
   
    {
      "id": "string",
      "metadata": {},
      "request": {
        "applicationId": "IDA",
        "referenceId": "mpartner-default-auth",
        "certificateData": "Copied certficate data fom the responce of step VII(mosip-signed)"
      },
      "requesttime": "2018-12-10T06:12:52.994Z",
      "version": "string"
    }

## Troubleshoot

- Please check if the domain name is correctly replaced.
- In case of errors related to timestamp please update the latest timestamp in the request.
- If the Swagger links are not available check if the services are running fine. 
	Swagger 2:- pms services.
	Swagger 3:- pms services.
	get certificate request :- ida services.
- In case you gett error in certifacte upload for either of ROOT, IDA, mpartner-default-auth reponse as ```certificate data already exist``` pls ignore as the certifcate exchange is done once.
- As of now this is WIP on this document. 
- For other descrepencies raise a github issue.
- Below is the example of how to get the get the certificate data from the response.
        ```
	{"id":null,"version":null,"responsetime":"2021-04-18T10:03:20.606Z","metadata":null,"response":{"certificate":"~~~-----BEGIN CERTIFICATE-----\nMIIDkDCCAnigAwIBAgIIzui2vr6fKUMwDQYJKoZIhvcNAQELBQAwbjELMAkGA1UE\nBhMCSU4xCzAJBgNVBAgMAktBMRIwEAYDVQQHDAlCQU5HQUxPUkUxDTALBgNVBAoM\nBElJVEIxGjAYBgNVBAsMEU1PU0lQLVRFQ0gtQ0VOVEVSMRMwEQYDVQQDDApNT1NJ\nUC1ST09UMB4XDTIwMTIxNTE1NDcxOVoXDTI1MTIxNTE1NDcxOVowbjELMAkGA1UE\nBhMCSU4xCzAJBgNVBAgMAktBMRIwEAYDVQQHDAlCQU5HQUxPUkUxDTALBgNVBAoM\nBElJVEIxGjAYBgNVBAsMEU1PU0lQLVRFQ0gtQ0VOVEVSMRMwEQYDVQQDDApNT1NJ\nUC1ST09UMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0IG5QpRMA1dZ\n2FRitMuNlzOCr+qsEZnFGdUH6npYMgNPSw7kJAHpo2CAo4WBNAgz6i1fASSqb8EZ\nXmxnKC9qW31zf8xmnwJNDMFIYctZTp1ZVG7yox+HeI4u//XymAGEg0U/bJ9FVpYr\n6TIbFIO7HzbB12qEwEmvniWKILqzf7qY6F+62GrJyFIwdpWkmlDMUdU4L9V3R10S\nwrNOTDkbHnLb34uwtBpaMHmYgOasaOXxCNcEzdOf56w6RTJmSla9TJgeXn0hikF1\ntxlHkv3Bw2T4y7eVL7NZeMhKkJJW0J4+hWm6nWzRG3Su31HoUIph1GFhrVrq/84B\nlOqHvpDIcwIDAQABozIwMDAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBS+Kdh1\nX3eiq7UDZ3jBJwoKzFjLaDANBgkqhkiG9w0BAQsFAAOCAQEASzHHVt79eqzzYKLi\ncquGoS31Flq+EKrUdm5zLIYQx9lolVmRveJEqE85x02dGu8MMWjsshQvnzbG0PET\nR5kED5tVRSYx1W/Da5uE7EzQpiYeKsakmSArnslB0kFB+8UGb3KlmCUrQC0C4Ufo\ngbl2zEj9slLgjHKYbvGlki3Sz0oFAdEjuBdbWOrOaMQMUu7OZjMl/scyMBAR0U5J\nURVAGbEniMrw7a1z3LynVerc1qDAbuX1l4njUnit+JbB9B7QPbTEKjce1/pdyvUc\n9SbJpoznaFTRNFyq1iI98hsk+Iu9AImohiCV2DsvVULzACVQXhdApbVZBqjHAHbn\nkQcdtw==\n-----END CERTIFICATE-----\n~~~","certSignRequest":null,"issuedAt":"2020-12-15T15:47:19.000Z","expiryAt":"2025-12-15T15:47:19.000Z","timestamp":"2021-04-18T10:03:20.606Z"},"errors":[]}
	``` 
	highlighted data between three tildas - ~~~ ~~~ in the above response is the example certificate data required.
	

