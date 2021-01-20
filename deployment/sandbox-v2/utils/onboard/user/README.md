# User and Client onboarding

## Function
The scripts here add users and clients to Keycloak and MasterDB.  The users typically are registration officers and supervisors, and admin.  

Clients are apps accessing Keycloak to acquire access token, example, `mosip-abis-client.`

## CSV
See example CSVs for user and client.  In column `role` specify roles separated by space.

## Config
1. Set the `server` url in `config.py`
1. If the url has HTTPS and server SSL certificate is self-signed then set `ssl_verify=False`.
1. Set `postgres` parameters.
1. Point to your CSVs

## Run
```
./user.py --help
```
