# Pre-registration Portal Captcha

## Pre-requisites
* Create a google recaptcha v2 ("I am not a Robot") from Google [Recaptcha Admin](https://www.google.com/recaptcha).
* Provide the captcha site and secret key when prompted as part of generate_captcha_secret.sh script.
## Install
Create the configmap and secret in `captcha` namespace by running the following:
```sh
./generate_captcha_secret.sh [kubeconfig]
```
Then run 'captcha' service by running the below command:
```sh
./install.sh
```