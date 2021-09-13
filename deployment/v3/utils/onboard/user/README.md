# User Onboarding

User onboarding is required for
1. Admin (who operates the Admin dashboard)
1. Registration officers (RO) who register residents at the registration center.:w


## Admin onboarding
1. Make sure a user is created in keycloak with GLOBAL_ADMIN and ZONAL_ADMIN roles
1. Set SERVER env variable to MOSIP API endpoint (example):
1. Obtain `mosip-regproc-client` password from Keycloak `mosip` realm. Use `get_pwd.sh` script given [here](../../../external/iam)
1. Set shell env variable
```sh
SERVER=https://api-internal.sandbox.xyz.net
```
1. Run 
```sh
python3 lib/map_user_zone.py $SERVER <user> <zone> <admin_user> <admin_pasword> <mosip-regproc-client password>
```
1. To update mapping if it already exists, run:
```sh
python3 lib/map_user_zone.py $SERVER <user> <zone> <admin_user> <admin_pasword> <mosip-regproc-client password> --update
```
