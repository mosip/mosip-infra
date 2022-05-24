# Admin module

## Install
```
./install.sh
```

## Admin proxy
Admin service accesses other services like Materdata and Keymanager and currently there is only one URL that is used to connect to both these services. This will get fixed in future versions, but as a an interim solution, Admin Proxy docker has been created, which is basically an Nginx proxy connecting to the above services with these URLs: 
```
http://admin-proxy/v1/masterdata
http://admin-proxy/v1/keymanager
```
The proxy is installed as part of `install.sh` script.

## Admin user
1. In Keycloak, create a user in `mosip` realm called `globaladmin` and assign role `GLOBAL_ADMIN`.  Make sure this user has strong credentials. 
2. Use this user to login into Admin portal via Keycloak. (Note that this user is already on-boarded as default user while uploading masterdata XLS in Kernel module)
3. _Strongly Recommended_: Create another user in keycloak with authentic name, email, details, strong password and `GLOBAL_ADMIN` role.  Assign global zone to this user via Admin portal, and then delete `globaladmin` from Keycloak and masterdata DB.  

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
1. Create user in Keycloak with appropriate role. 
1. Map the user to a Zone using Admin portal.
1. Map user to a registration center (in case of Registration Officer/Supervisor) using Admin portal.

