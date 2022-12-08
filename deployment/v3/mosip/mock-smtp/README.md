# Mock SMTP and Mock SMS

## Introduction
The chart here installs a Mock SMTP and Mock SMS accessed over an https URL. 

## Install
* The url must point to your internal loadbalancer as `https://smtp.sandbox.xyz.net/` will typically not be open to public.
* For more details refer [mock-smtp-repo](https://github.com/mosip/mock-smtp)
* Make sure to update the below properties in the config's `kernel-default.properties` file.
  ```
  #kernel-default.properties
  #Email properties
  spring.mail.properties.mail.smtp.starttls.required=false
  spring.mail.properties.mail.smtp.starttls.enable=false
  spring.mail.properties.mail.smtp.auth=true
  mosip.kernel.mail.proxy-mail=false

  #SMS properties
  mosip.kernel.sms.enabled:true
  mosip.kernel.sms.country.code: +91
  mosip.kernel.sms.number.length: 10
  mosip.kernel.sms.api:http://mock-smtp.mock-smtp:8080/sendsms
  mosip.kernel.sms.sender:AD-MOSIP
  mosip.kernel.sms.password:dummy
  mosip.kernel.sms.route:mock
  mosip.kernel.sms.authkey:dummy
  
  ```
* Install
```sh
./install.sh
```
