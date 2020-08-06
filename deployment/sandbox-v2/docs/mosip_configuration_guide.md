# MOSIP Configuration Guide

## Pre-install configuration

Configurations for all the modules are specified via property files located in `roles/config-repo/files/properties`.  Modify these files as below. Note that the changes here apply only during the inital install of MOSIP. For config changes post install refer to section [Post install configuration](#post-install-configuration).

### Captcha
* Captcha is needed for Pre-Reg UI only. Obtain captcha for the sandbox domain from "Google Recaptcha Admin".  Get _reCAPTCHA v2 "I'm not a robot"_ keys. 
* Set captcha:
  * File: `roles/config-repo/files/properties/pre-registration.mz.properties`
  * Properties:
    ```
    google.recaptcha.site.key=sitekey
    google.recaptcha.secret.key=secret
    ```

### OTP settings
To receive (one-time password) OTP over email and SMS set properties as below.  If you do not have access to Email and SMS gateways, you may want to run MOSIP in Proxy OTP mode in which case skip to [Proxy OTP Settings](#proxy-otp-settings). 
* SMS:
  * File: `roles/config-repo/files/properties/kernel-mz.properties`
  * Properties:  `kernel.sms.*`

* Email:
  * File: `roles/config-repo/files/properties/kernel-mz.properties`
  * Properties:
    ```
    mosip.kernel.notification.email.from=emailfrom
    spring.mail.host=smtphost
    spring.mail.username=username
    spring.mail.password=password
    ```
### Proxy OTP settings

To run MOSIP in Proxy OTP mode set the following:
* Proxy: 
  * File: `roles/config-repo/files/properties/application-mz.properties` 
  * Properites:
    ```
    mosip.kernel.sms.proxy-sms=true
    mosip.kernel.auth.proxy-otp=true
    mosip.kernel.auth.proxy-email=true
    ```
Note that the default OTP is set to `111111`.

## Post install configuration

During installation, the properties from `roles/config-repo/files/properties` are copied to a local git repo on the console machine at `/srv/nfs/mosip/config_repo`.  To modify properties after modules are running:  

    ```
    $ sudo su root  # On console
    $ cd /srv/nfs/mosip/config_repo   
    - Modify files
    $ git commit -m "<comment>" files
    - Restart affected services (pods). You need not restart the config server. The latest checked-in properties will get picked up.
    ```
