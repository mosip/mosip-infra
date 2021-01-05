# Device onboarding

## Process
1. Onboard device partner assigned in `data/spec/*.json` using [partner onboarding scripts](../partner/). For Device Provider it suffices to add just add partner without any policies and certificates. (TODO: confirm this claim!)
1. Onboard `superadmin` user using [user onboarding scripts](../user/)
1. Make sure partner manager assigned in `config.py` is available in Keycloak.
1. Add device spec

## Attributes:

## config.py
1. Check server (provide internal url if on VPN)
1. primary language

### Device spec
* **id**: Unique id
* **type**: One of the types in `reg_device_type` table of `mosip_regdevice` db.
* **subtype**: One of the sub types in `reg_device_subtype` table of `mosip_regdevice` db.

## Notes
* Device type and sub type are  somewhat "hardcoded" - so don't change them.  
