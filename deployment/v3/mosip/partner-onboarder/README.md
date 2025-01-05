# Partner Onboarder

## Overview
Loads certs for default partners for sandbox. Refer [mosip-onboarding repo](https://github.com/mosip/mosip-onboarding).

## Install 
* Create a directory for onboarder on the NFS server at `/srv/nfs/<sandbox>/onboarder/`:
```
mkdir -p /srv/nfs/mosip/<sandbox>/onboarder/
```
* Ensure the directory has 777 permissions:
```
chmod 777 /srv/nfs/mosip/<sandbox>/onboarder
```
* Add the following entry to the /etc/exports file:
```
/srv/nfs/mosip/<sandbox>/onboarder *(ro,sync,no_root_squash,no_all_squash,insecure,subtree_check)
```
* Set `values.yaml` to run onboarder for specific modules.
* run `./install.sh`.
```
./install.sh
```
# Troubleshootings

* After completion of the job, a very detailed `html report` is prepared and stored at https://onboarder.{sandbox_base_url}.mosip.net

* The user can go and view the same for more information or response messages.

### Commonly found issues 

 1. KER-ATH-401: Authentication Failed
 
    Resolution: You need to provide correct secretkey for mosip-deployment-client.
 
 2. Certificate dates are not valid

    Resolution: Check with admin regarding adding grace period in configuration.
 
 3. Upload of certificate will not be allowed to update other domain certificate
 
    Resolution: This is expected when you try to upload `ida-cred` certificate twice. It should only run once and if you see this error while uploading a second      time it can be ignored as the cert is already present.
