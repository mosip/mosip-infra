# Config Server Secrets

This module generates and install secrets required by config-server.

## Install
```sh
./install.sh [kubeconfig]
```
## Secrets to be updated for Migartion scenerios
### 1.1.5.5-P1 to 1.2.0.1
* After installing Conf secrets in 1.2.0.1 update below mentioned keys with values from V2 configuration files.
*  | Property file (V2 conf) | parameters | keys (Conf-screts) |
   |---|---|---|
   | id-authentication-mz.properties | ida-websub-authtype-callback-secret | ida-websub-authtype-callback-secret |
   | id-authentication-mz.properties | ida-websub-ca-certificate-callback-secret | ida-websub-ca-certificate-callback-secret |
   | id-authentication-mz.properties | ida-websub-credential-issue-callback-secret | ida-websub-credential-issue-callback-secret |
   | id-authentication-mz.properties | ida-websub-hotlist-callback-secret | ida-websub-hotlist-callback-secret |
   | id-authentication-mz.properties | ida-websub-partner-service-callback-secret | ida-websub-partner-service-callback-secret |
   | mimoto-mz.properties | mosip.partner.crypto.p12.password | mosip-partner-crypto-p12-password |
   | print-mz.properties | mosip.event.secret| print-websub-hub-secret |
