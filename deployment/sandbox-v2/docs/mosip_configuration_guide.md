# MOSIP Configuration Guide

## Pre-install configuration

Configurations for all modules are specified via property files assumed located in Github repository. For example, for this sandbox the properties are located at `https://github.com/mosip/mosip-config` within `sandbox` folder. You may have your own repository following the same name and structure of `sandbox` folder. The repo may be private. Configure the following parameters in `group_vars.all.yml` as below (example):
```
config_repo:
  git_repo_uri: https://github.com/mosip/mosip-config 
  private: false 
  search_folders: sandbox 
  local_git_repo:
    enabled: false
```

If `local_git_repo` is enabled, the repo will be cloned to the NFS mounted folder and config server will pull the properties locally. This option is useful when sandbox is secured with no Internet access. You may git check-in any changes locally.  However, note that if you want the changes to reflect in the parent Github repo, you will have to push them manually.  There is no need to restart config-server pod when you make changes in the config repo.

### Captcha
* Captcha is needed for Pre-Reg UI only. Obtain captcha for the sandbox domain from "Google Recaptcha Admin".  Get _reCAPTCHA v2 "I'm not a robot"_ keys. 
* Set captcha:
  * File: `pre-registration.mz.properties`
  * Properties:
    ```
    google.recaptcha.site.key=sitekey
    google.recaptcha.secret.key=secret
    ```

### OTP settings
To receive (one-time password) OTP over email and SMS set properties as below.  If you do not have access to Email and SMS gateways, you may want to run MOSIP in Proxy OTP mode in which case skip to [Proxy OTP Settings](#proxy-otp-settings). 
* SMS:
  * File: `kernel-mz.properties`
  * Properties:  `kernel.sms.*`

* Email:
  * File: `kernel-mz.properties`
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
  * File: `application-mz.properties` 
  * Properites:
    ```
    mosip.kernel.sms.proxy-sms=true
    mosip.kernel.auth.proxy-otp=true
    mosip.kernel.auth.proxy-email=true
    ```
Note that the default OTP is set to `111111`.

### Country specific customisations
If you are installing default sandbox you may skip this step.  If you have country specific configuration refer to [Country Specific Deployment](https://github.com/mosip/mosip-infra/blob/master/deployment/sandbox-v2/docs/country_deployment.md)

