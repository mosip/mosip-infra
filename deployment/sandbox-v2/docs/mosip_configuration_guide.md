# MOSIP Configuration Guide

## DNS
By default a private DNS (CoreDNS) is installed on the console machine and `/etc/resolv.conf` on all machines points to this DNS.  However, you would like to use cloud providers DNS (like Route53 on AWS), disable the private DNS installation by setting the following flag in `group_vars/all.yml`:
```
coredns:
  enabled: false  # Disable to use Cloud provided DNS 
```
Make sure your cloud deployment takes care of DNS routing.  For AWS, uncomment the Route53 code in the scripts provided in `terraform/aws/sandbox`

The playbook `corends.yml` setups corends and updates `/etc/resolv.conf` file on all machines.  In case a machine has to be rebooted, run the playbook again to restore `/etc/resolv.conf`.

## Sandbox access
The default sandbox installation requires you to have a public domain name such that the domain name points to console machine. However, if you would like to access sandbox on your internal network (over VPN for example) then set the following in `group_vars/all.yml`:
```
sandbox_domain_name: '{{inventory_hostname}}'
site:
  sandbox_public_url: 'https://{{sandbox_domain_name}}'
  ssl:
    ca: 'selfsigned'   # The ca to be used in this deployment
```
This is will generate a self-signed certificate and the sandbox access url would be `https://console.sb/` 

## Secrets
All secrets are stored in `secrets.yml`.  For a secure sandbox, edit the file and update all passwords.  Defaults may be used for development and testing, but be aware that the sandbox will not be secure with defaults. To edit `secrets.yml`:
```
$ av edit secrets.yml
```
If you update postgres passwords, then their ciphers will have to be updated in property files.  See section on Config Server below.

All the passwords used in `.properties` have been added in `secrets.yml` - some of them for pure informational purpose - to be able to find out the text password. IMPORTANT: if you change any password in `.properties` make sure `secrets.yml` is updated.

## Private dockers
If you are pulling dockers from private registry in Docker Hub, then provide the Docker Hub credentails in `secrets.yml` and set following flag in `group_vars/all.yml`:
```
docker_hub:
  private: true
```

Update `versions.yml` with your docker versions.

## Config server

Configurations for all modules are specified via property files located in Github repository. For example, for this sandbox the properties are located at `https://github.com/mosip/mosip-config` within `sandbox` folder. You may have your own repository with a folder containing property files. The repo may be private. Configure the following parameters in `group_vars/all.yml` as below (example):
```
config_repo:
  git_repo_uri: https://github.com/mosip/mosip-config 
  branch: 1.1.2
  private: false 
  username: <your github username>
  search_folders: sandbox 
  local_git_repo:
    enabled: false
```

If `private: true` then update your github username as above in `group_vars/all.yml`.  Update your password in `secrets.yml`.

If `local_git_repo` is enabled, the repo will be cloned to the NFS mounted folder and config server will pull the properties locally. This option is useful when sandbox is secured with no Internet access. You may git check-in any changes locally.  However, note that if you want the changes to reflect in the parent Github repo, you will have to push them manually.  There is no need to restart config-server pod when you make changes in the config repo.
  
If you have modified default passwords in `secrets.yml`, generate the ciphers of these passwords and update property files for the changed passwords. The ciphers may be generated from the console machine after the config server is up using the following `curl` command:
```
$  curl http://mzworker0.sb:30080/config/encrypt -d  <string to be encrypted>
```
The above command to config server pod via ingress on MZ.

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

### Registration Client settings
For setting up MOSIP server to work with registration client refer to [Reg Client Install](reg_client_install.md).

### Country specific customisations
If you are installing default sandbox you may skip this step.  If you have country specific configuration refer to [Country Specific Deployment](country_deployment.md)

