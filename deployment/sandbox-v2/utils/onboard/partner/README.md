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
    server='<your sandbox doman>'
    ```
1. Make sure users and corresponding roles are updated in Keycloak.  Refer to `config.py` for users and roles.
1. Populate the CSVs in `csv` folder.  
1. Update/add any policies in `policies` folder.  The schema for policies are given here:
    * [Auth policy schema](https://github.com/mosip/mosip-config/blob/1.1.3/sandbox/auth-policy-schema.json)
    * [Data share schema](https://github.com/mosip/mosip-config/blob/1.1.3/sandbox/data-share-policy-schema.json)
1. Create CA and partner certificates:
    ```
    $ ./create_certs.py
    ```
1.  Run the script as below:
    ```
    $ ./partner.py <action>
    For actions see help. The actions here map to steps above:  
    $ ./partner.py --help
    ```

## Various attributes
* **partnerType**: Partner types are pre-populated in `partner_type` table of `mosip_pms` DB and must not be altered.
* **policyType**:  One of `Auth/DataShare/CredentialIssuance` 
* **authTokenType**: One of `random/partner/policy`
* **partnerDomain**: One of `AUTH/DEVICE/FTM`.  These values are specified as `mosip.kernel.partner.allowed.domains` property in `kernel-mz.properties` file.


