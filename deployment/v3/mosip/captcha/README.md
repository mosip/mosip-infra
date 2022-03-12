# Pre-registration Portal Captcha

* Create a google recaptcha v2 ("I am not a Robot") from Google [Recaptcha Admin](https://www.google.com/recaptcha).
* Give the domain name as your PreReg domain name.  Example "prereg.sandbox.xyz.net".

Create the configmap and secret in `prereg` namespace by running the following:
```sh
./install.sh [kubeconfig]
```
