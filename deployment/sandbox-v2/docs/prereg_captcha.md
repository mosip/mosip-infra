### Captcha
* If you would like to enable Captcha for Pre-Reg UI, obtain Captcha for the sandbox domain from "Google Recaptcha Admin".  Get _reCAPTCHA v2 "I'm not a robot"_ keys. 
* Set Captcha:
  * File: `pre-registration.mz.properties`
  * Properties:
    ```
    google.recaptcha.site.key=sitekey
    google.recaptcha.secret.key=secret
    ```
