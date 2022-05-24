# Parnter Onboarding 

## Overview
The folder here contains [Postman](https://www.postman.com/) collection for onboarding a partner. The collection may be run using Postman app, browser plugin or with command line utility `newman`.

## Using the collection
* To use the collection the user needs to have latest postman application installed on local system.
* After creating a profile in postman the user can import the collection from infra and start using it.
* There is another postman_enviornment.collection, which can be imported as well. This collection already contains all the required variables, however the user needs to change the variable values as per requirement and usage.

## Automated_Certificate_Upload
* This collection is meant to upload all the certificates which are needed just after deployment for the modules.
* We upload IDA module crtificates, Resident Module certificates, Print module and Abis module certificates through this collection.
* The collection is set in such a way that the user only has to set the url/baseurl value as a variable in postman and rest of the things will be taken care of by the postman.
* For example:
In the second step:
Get IDA internal Root certificate, after getting the certificate in response, the user doesn’t have to copy or store it anywhere, it will be auto stored as {{rootcert}} in postman variables.

## Partner_onboarding_modular
This collection is meant to register and upload all types of partners into mosip Framework.
The types of supported partners are:

1. Auth_Partner
2. Credential_partner
3. MISP partner
4. Device Provider
5. FTM partner
6. Manual adjudication partner

 
The details about each partner and their requirement and details of unboarding can be found [here](https://nayakrounak.gitbook.io/mosip-docs/partners).

This collection is an accumulation of all of the APIS required to onboard any partner.

For example, while Onboarding Device_provider partner
* The Admin will first generate a user for the interested partner in keycloak and provide certain roles to it.
* Next using the credentials generated above by admin,the partner will authenticate and then self register.
* After which the partner will provide the required certificates to Aadmin,which admin will upload.
* After successful upload admin will share a mosip-signed certificate back to the partner, which partner can use for mosip-related trust validation.

Note- There is another variable collection shared in mosip-infra which needs to be imported to postman, that collection contains all the required variables and it has to be changed as per requirement.
