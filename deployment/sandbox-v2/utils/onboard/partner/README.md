# Partner onboarding

## Onboarding steps
1. Add policy group
1. Add policy 
1. Add partner
1. Create partner and CA certificates
1. Upload certificates
1. Map partner to policy
1. Add MISP

## Script
1. Make sure you run `./preinstall.sh`  for Python dependencies.
1. Point to your sandbox in `config.py`:
    ```
    server='https://<your sandbox domain>'
    ```
1. Make sure users and corresponding roles are updated in Keycloak.  Refer to `config.py` for users and roles. Default sandbox installation automatically adds these users in Keycloak.
1. Populate the JSONs in `data` folder.  
1. Update/add any policies in `policies` folder.  The schema for policies are given here:
    * [Auth policy schema](https://github.com/mosip/mosip-config/blob/1.1.3/sandbox/auth-policy-schema.json)
    * [Data share schema](https://github.com/mosip/mosip-config/blob/1.1.3/sandbox/data-share-policy-schema.json)
1. Create CA and partner certificates:
    ```
    $ ./create_certs.py data/certs
    ```
1.  Run the script as below:
    ```
    $ ./partner.py <action>
    For actions see help. The actions here map to steps above:
    $ ./partner.py --help
    ```
1. The steps are illustrated in [onboard playbook](../../../playbooks/onboard/partner.yml)

## Various attributes
* **partnerType**: Partner types are pre-populated in `partner_type` table of `mosip_pms` DB and must not be altered.
* **policyType**:  One of `Auth/DataShare/CredentialIssuance` 
* **authTokenType**: One of `random/partner/policy`
* **partnerDomain**: One of `AUTH/DEVICE/FTM`.  These values are specified as `mosip.kernel.partner.allowed.domains` property in `kernel-mz.properties` file.
* **app_id**: App Id from where certificate has to be pulled. Generally IDA.
* **cert_source**: `internal/generated/provided`. Cert may be already inside mosip, or has been provided external or needs to be generated.
* **overwrite**: Applicable with `cert_source==generated`. Whether to regenerate.
* **cert.country**: 2 Character country code
* **org_name**: Must match partner name.

## Certs
For internal certs the partner name must match the oranization name given in the cert.

## Policy group
* Multiple policies can be within policy group.
* Partner - policy group mapping is 1-1. 
* Within a policy group, partner can select multiple policies.

## Notes
* While adding a partner the same automatically gets added in Keycloak as well.
* IDA module is also like a partner to mosip system.  For biometric auth in Registration Processor, IDA Internal service is used.  In this case IDA has to be onboarded as `Online_Verification_Partner` with datashare policy.
* To generate p12 keystore for private key and certificate needed for print service, use this command:
```
$ openssl pkcs12 -export -in dummy.pem -inkey privkey.pem -out keystore.p12 [-name alias]
```
