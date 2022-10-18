# Regclient 

## Introduction
The chart here installs a regclient downloader accessed over an http URL. 

## Install
* Make sure global configmap contains the url for regclient host e.g. `regclient.sandbox.xyz.net`.
* The url must point to your internal loadbalancer as regclient will typically not be open to public.
* Install
```sh
./install.sh
```
## Download
The download URL will be available at `https://your-reglient-host`. Example: `https://reglient.sandbox.xyz.net`.

## Customization
If you want to add extra environment variables to the regclient docker do follow the below mentioned steps.
1. Add the variables in extraEnvVars section of the sample 'values.yaml.sample' file given.
2. Rename 'values.yaml.sample' file to 'values.yaml'.
3. Append 'values.yaml' to the install.sh script as '-f values.yaml' to include the environmental variables to the regclient docker.
 
```
helm -n $NS install regclient mosip/regclient \
  --set regclient.upgradeServerUrl=https://$INTERNAL_HOST \
  --set regclient.healthCheckUrl=$HEALTH_URL \
  --set regclient.hostName=$INTERNAL_HOST \
  --set istio.host=$REGCLIENT_HOST \
  --wait \
  -f values.yaml \
  --version $CHART_VERSION 
  ```
  
## Set up of regclient
Follow the guide [here](https://github.com/mosip/registration-client/blob/develop/README.md)
