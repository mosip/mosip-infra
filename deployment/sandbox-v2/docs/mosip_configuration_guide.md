## MOSIP Configuration Guide

Configurations for all the modules are specified via property files located in `roles/config-repo/files/properties`.  Modify these files as below.

### Captcha
* Obtain captcha for the sandbox domain from "Google Recaptcha Admin".  Get _reCAPTCHA v2 "I'm not a robot"_ keys. 
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

