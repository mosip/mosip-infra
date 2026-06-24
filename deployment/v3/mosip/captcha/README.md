# Pre-registration Portal Captcha

## Pre-requisites
* Create a google recaptcha v2 ("I am not a Robot") from Google [Recaptcha Admin](https://www.google.com/recaptcha).
* Provide the captcha site and secret key when prompted as part of install script.
## Install
Create the configmap and secret in `captcha` namespace by running the following:
* To install captcha.
```sh
./install.sh [kubeconfig]
```

## Restart
* To restart captcha.
```sh
./restart.sh
```
## Delete
* To delete captcha.
```sh
./delete.sh
```

