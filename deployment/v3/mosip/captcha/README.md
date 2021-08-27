# Captcha for PreRegistration UI

Create a google recaptcha v3 ("I am not a Robot") from Google Recaptcha Admin.  Give the domain name as your PreReg domain name.  Example "prereg.sandbox.xyz.net".

Create the configmap and secret in `prereg` namespace by running the following:
```sh
./captcha.sh <site key> <secret>
```
