# User Onboarding

## Function
The scripts here add usersto Keycloak and MasterDB.  The users typically are registration officers and supervisors, and admin.  

## Process
1. Onboard Device Provider partner
1. Add user to Keycloak
1. Add user to MasterDB

## JSON
See example JSONs in `data/` folder.

## Config
1. Set the `server` url in `config.py`
1. If the url has HTTPS and server SSL certificate is self-signed then set `ssl_verify=False`.
1. Set `postgres` parameters.

## Run
```
./onboard.py --help
```
You may specify individual JSON file or an entire folder as input.  In folder is specified, all JSONs are picked up recursively.

WARNING: Default behaviour of the scripts is to **update** a record if it already exists.  So be mindful of any changes in the JSONs.  You will not be prompted or warned for any updates to existing records.

