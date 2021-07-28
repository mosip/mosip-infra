# Partner onboarding
## Onboarding steps
1. Add policy group
1. Add policy 
1. Add partner
1. Create partner and CA certificates
1. Upload certificates
1. Map partner to policy
1. Add MISP

## Adding Auth Partner 
1. Add auth partner `add_partner.py`
1. Get api request key
```
python3 lib/api_key_request.py $SERVER auth-partner-2 mpolicy-default-auth <user> <password>
```
1. Extractors
```
python3 lib/add_extractor.py $SERVER auth-partner-2 mpolicy-default-auth photo face mock 1.1 <user> <password>
python3 lib/add_extractor.py $SERVER auth-partner-2 mpolicy-default-auth iris iris mock 1.1 <user> <password>
python3 lib/add_extractor.py $SERVER auth-partner-2 mpolicy-default-auth fingerprint finger mock 1.1 <user> <password>
```
1. Approve request
```
python3 lib/approve_apikey_request.py $SERVER 498721 <user> <password>

```
## Various attributes
* **partnerType**: Partner types are pre-populated in `partner_type` table of `mosip_pms` DB and must not be altered.
* **policyType**:  One of `Auth/DataShare/CredentialIssuance` 
* **authTokenType**: One of `random/partner/policy`
* **partnerDomain**: One of `AUTH/DEVICE/FTM`.  These values are specified as `mosip.kernel.partner.allowed.domains` property in `kernel-mz.properties` file.  For registration devices specify DEVICE.
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
$ openssl pkcs12 -export -inkey pvt_key.pem  -in cert.pem  -out key.p12
```
