# Mock SMTP

## Introduction
The chart here installs a Mock SMTP accessed over an https URL. 

## Install
* The url must point to your internal loadbalancer as `https://api-internal.sandbox.xyz.net/mocksmtp` will typically not be open to public.
* For more details refer [mock-smtp-repo](https://github.com/mosip/mock-smtp)
* Make sure to update the below properties in the config's `kernel-default.properties` file.
  ```
  spring.mail.properties.mail.smtp.starttls.required=false
  spring.mail.properties.mail.smtp.starttls.enable=false
  spring.mail.properties.mail.smtp.auth=true
  mosip.kernel.mail.proxy-mail=false
  ```
* Install
```sh
./install.sh
```