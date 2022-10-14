# Partner Onboarder

## Overview
Loads certs for default partners for sandbox. Refer [mosip-onboarding repo](https://github.com/mosip/mosip-onboarding).

## Install 
```
./install.sh
```
#Troubleshootings

###After completion of the job ,a very detailed html report is prepared and stored at https://onboarder.{sandbox_base_url}.mosip.net

###The user can go and checkout the same ,for more info or response messages .

###Some of the commonly found issues are listed below.


 ###1.KER-ATH-401: Authentication Failed 
 ###Resolution :You need to provide correct secretkey for mosip-deployment-client.
 
 ###2.Certificate dates are not valid
 ###Resolution:Check with admin regarding adding grace period in configuration.
 
 ###3.Upload of certificate will not be allowed to update other domain certificate
 ###Resolution:This is expected when you try to upload ida-cred certificate twice.It should only run once and if you see this error while uploading a second time                 it can be ignored as the cert is already present.



