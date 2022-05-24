# Certificate Upload

## Overview
The folder here contains [Postman](https://www.postman.com/) collection for uploading certificates for MOSIP integrated modules. This collection can be run using Postman application, browser plugin or with command line interface `newman`.

## Using the certificate-upload collection
* To use the collection the user needs to have latest version of postman/newman installed on local system.
* In postman the user can import the API collection and the variable collection from mosip-infra and start using it.
* In newman the user can download the API collection and the variable collection from mosip-infra and start using it.
* This variable collection already contains all the required variables, however the user needs to change the variable values as per requirement and usage.For example the secretkey variable will always be different for different environments.
* This API collection is meant to upload all the certificates which are needed just after deployment for the modules.
* We upload IDA module crtificates, resident module certificates, print module and abis module certificates through this collection.
* This API collection is automated in such a way that the user does not have to copy or store any certificates anywhere,rather the scripts of postman will do that.The only required user-intervention is to set/reset the values of the two variables in the variable collection. e.g url and secretkey. 

## To run the collection in newman 
*To get a comprehensive report of all requests and responses and tests ,the user can install a newman additional reporting tool by using the command.
 *npm install -g newman-reporter-htmlextra
 *After successful installation of same ,the command to run the API collection along with the variable collection will be 
 *newman run certificate-upload.postman_collection.json --delay-request 2000 -e certificate-upload.postman_environment.json -r htmlextra --reporter-htmlextra-export ./certificate-report.html
 *The --delay-request 2000 command is used to provide a 2000 ms or 2 second gap between each requests and it can be customised as per user's needs.
 *The detailed report of all the requests and responses will be stored in the certificate-report.html file in the same directory.
