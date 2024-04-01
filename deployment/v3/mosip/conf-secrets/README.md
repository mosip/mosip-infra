# Config Server Secrets

This module generates and install secrets required by config-server.

Note: 
* The conf-secrets must not be deleted in any case of re-deployment, upgrade or migration process as we have separated the conf-secrets from config-server to ensure conf-secrets are not deleted.
* Incase if you have a scenario where you have to delete the conf-secrets from the environment make sure to run `delete.sh` script as the script delete's the helm chart and takes the backup of the existing `conf-secrets-various` secret.


## Install
```sh
./install.sh [kubeconfig]
```

## Delete 
```
./delete.sh [kubeconfig]
```

## Secrets to be updated for Migartion scenerios
### 1.1.5.5-P1 to 1.2.0.1
* After installing Conf secrets in 1.2.0.1 update below mentioned keys with values from V2 configuration files.
*  | Property file (V2 conf)         | Property file (V3 conf)              | parameters | keys (Conf-screts) |
   |---------------------------------|--------------------------------------|--|--|
   | id-authentication-mz.properties | id-authentication-default.properties | ida-websub-authtype-callback-secret | ida-websub-authtype-callback-secret |
   | id-authentication-mz.properties | id-authentication-default.properties | ida-websub-ca-certificate-callback-secret | ida-websub-ca-certificate-callback-secret |
   | id-authentication-mz.properties | id-authentication-default.properties | ida-websub-credential-issue-callback-secret | ida-websub-credential-issue-callback-secret |
   | id-authentication-mz.properties | id-authentication-default.properties | ida-websub-hotlist-callback-secret | ida-websub-hotlist-callback-secret |
   | id-authentication-mz.properties | id-authentication-default.properties | ida-websub-partner-service-callback-secret | ida-websub-partner-service-callback-secret |
   | mimoto-mz.properties            | mimoto-default.properties            | mosip.partner.crypto.p12.password | mosip-partner-crypto-p12-password |
   | print-mz.properties             | print-default.properties             | mosip.event.secret | print-websub-hub-secret |
   | id-authentication-mz.properties | id-authentication-default.properties | mosip.ida.kyc.token.secret | mosip-ida-kyc-token-secret |
   | mimoto-mz.properties            | mimoto-default.properties            | wallet.binding.partner.api.key | mimoto-wallet-binding-partner-api-key |   
   | id-authentication-mz.properties | id-authentication-default.properties | mosip-kernel-tokenid-uin-salt | mosip-kernel-tokenid-uin-salt |
   | id-authentication-mz.properties | id-authentication-default.properties | mosip.kernel.tokenid.partnercode.salt | mosip-kernel-tokenid-partnercode-salt |
   | resident-mz.properties          | resident-default.properties          | resident.websub.authtype.status.secret | resident-websub-authtype-status-secret |
   | resident-mz.properties          | resident-default.properties          | resident.websub.credential.status.update.secret | resident-websub-credential-status-update-secret |
   | resident-mz.properties          | resident-default.properties          | resident.websub.auth.transaction.status.secret | resident-websub-auth-transaction-status-secret |
   | id-authentication-mz.properties  | id-authentication-default.properties | ida-websub-masterdata-templates-callback-secret | ida-websub-masterdata-templates-callback-secret |
   | id-repository-mz.properties | id-repository-default.properties | mosip.idrepo.websub.vid-credential-update.secret | idrepo-websub-vid-credential-update-secret |
