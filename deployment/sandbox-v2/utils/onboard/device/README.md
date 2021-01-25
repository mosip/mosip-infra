# Device onboarding

## Process
1. Onboard device partner assigned in `data/spec/*.json` using [partner onboarding scripts](../partner/). For Device Provider it suffices to add just add partner without any policies and certificates. (TODO: confirm this claim!)
1. Onboard `superadmin` user using [user onboarding scripts](../user/)
1. Make sure partner manager assigned in `config.py` is available in Keycloak.
1. Add device spec

## JSONs
See example JSONs in `/data/` folder.  Note that Device Provider does not require any policies.  

NOTE: Device type and sub type are  somewhat "hardcoded" - so don't change them.  

## config.py
1. Set the `server` url in `config.py`
1. If the url has HTTPS and server SSL certificate is self-signed then set `ssl_verify=False`.
1. Set `postgres` parameters.

### Device spec
* **id**: Unique id
* **type**: One of the types in `reg_device_type` table of `mosip_regdevice` db.
* **subtype**: One of the sub types in `reg_device_subtype` table of `mosip_regdevice` db.

## Run
```
$ ./onboardy --help
```
You may specify individual JSON file or an entire folder as input.  In folder is specified, all JSONs are picked up recursively.

WARNING: Default behaviour of the scripts is to **update** a record if it already exists.  So be mindful of any changes in the JSONs.  You will not be prompted or warned for any updates to existing records.
