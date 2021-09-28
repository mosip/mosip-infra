# Admin module

## Install
```
./install.sh
```
## Admin user
1. Create a user in 'mosip' realm and assign roles GLOBAL_ADMIN and ZONAL_ADMIN. Use this to login via Keycloak for accessing the admin portal.
1. Add the same username to masterdata `zone_user` table using `map_user_zone.py`

## Admin portal
Access the portal with following URL:
```
https://<your-internal-api-host>/admin-ui/

Example:
https://api-internal.sandbox.xyz.net/admin-ui/
```
Your wireguard client must be running for this access.


