# Admin module

## Install
```
sh install.sh
```
## Admin user
1. Create a user in 'mosip' realm and assign roles GLOBAL_ADMIN and ZONAL_ADMIN. Use this to login via Keycloak for accessing the admin portal.
1. Add the same username to masterdata zone_user table using map_user_zone.py

