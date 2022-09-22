# Mock SMTP

## Introduction
The chart here installs a Mock SMTP accessed over an https URL. 

## Install
* The url must point to your internal loadbalancer as `https://api-internal.sandbox.xyz.net/mocksmtp` will typically not be open to public.
* For more details refer [mock-smtp-repo](https://github.com/mosip/mock-smtp)
* Install
```sh
./install.sh
```