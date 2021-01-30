# Integration with external print service

## Introduction
MOSIP provides a [reference implementation] of print service that intefaces with the mosip system.  

## Print process flow


## Integration steps

Ensure the following:

1. Websub is running on mosip and accessible externally via nginx as `https://<sandbox domain name>/websub`. In the sandbox, websub runs in DMZ and nginx as been configured for this access. 

1. Your service is able to register a topic with Websub with a callback url.

1. The callback url is accessible from mosip websub.      

1. Print policy has been created (be careful about encryption enabled/disabled).

1. Print partner created and certs uploaded.

1. The private and certificate of print partner is converted to p12 keystore format.  You may use the following command:
    ```
    $ openssl pkcs12 -export -out key.p12 -in cert.pem -inkey pvt_key.pem -passout pass: -nokeys
    ```
1. This p12 key is used in your print service (you will need to compile your code).

1. Your print service reads the relevant (expected) fields from received credentials.

1. Your print service is able to update mosip datashare service after successfully reading the credentials.


