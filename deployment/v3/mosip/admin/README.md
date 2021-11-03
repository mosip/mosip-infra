# Admin module

## Install
```
./install.sh
```
## Admin user
1. Create a user in 'mosip' realm called 'globaladmin' and assign roles GLOBAL_ADMIN.  Make sure this user has strong credentials.
1. Use this user to login into Admin portal via Keycloak.

## Admin portal
Access the portal with following URL:
```
https://<your-internal-api-host>/admin-ui/

Example:
https://api-internal.sandbox.xyz.net/admin-ui/
```
Your wireguard client must be running for this access.


