# Admin module

## Install
```
./install.sh
```
## Admin user
1. In Keycloak, create a user in `mosip` realm called `globaladmin` and assign role `GLOBAL_ADMIN`.  Make sure this user has strong credentials. 
2. Use this user to login into Admin portal via Keycloak. (Note that this user is already on-boarded as default user while uploading masterdata XLS in Kernel module)
3. _Recommended_: Create another user in keycloak with authentic name, email, details and strong password. Assign global zone to this user via Admin portal, and then delete `globaladmin` from Keycloak and masterdata DB.  

## Admin portal
Access the portal with following URL:
```
https://<your-internal-api-host>/admin-ui/

Example:
https://api-internal.sandbox.xyz.net/admin-ui/
```
Your wireguard client must be running for this access.

## Onboarding
Use the portal to onboard user, machine, center.

Note that for onboarding a user (like a Zonal Admin or Registration Officer),
1. Create user in Keycloak first with appropriate role. 
1. Map the user to a Zone using Admin portal.
1. Map user to a registration center (in case of Registration Officer/Supervisor).

