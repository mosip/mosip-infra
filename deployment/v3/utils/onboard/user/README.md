# User Onboarding

User onboarding is required for
1. Admin (who operates the Admin dashboard)
1. Registration officers (RO) who register residents at the registration center.:w

## Prerequisites
1. Python3.9
1. Set up python3.9 virtual env
```sh
mkdir ~/.venv
python3.9 -m venv ~/.venv/partner
```
1. Switch to virtual env 
```
source ~/.venv/partner/bin/activate
```
1. Install required modules
```sh
pip install -r requirements.txt
```

## Admin onboarding
1. Make sure a user is created in keycloak with GLOBAL_ADMIN and ZONAL_ADMIN roles
1. Set SERVER env variable to MOSIP API endpoint (example):
1. Obtain `mosip-regproc-client` password from Keycloak `mosip` realm. Use `get_pwd.sh` script given [here](../../../external/iam)
1. Set shell env variable
```sh
SERVER=https://api-internal.sandbox.xyz.net
```
## Map user to zone
1. Run  
```sh
python lib/map_user_zone.py --help
```
IMPORTANT: If this sequence is important - map zone first and then reg center.

## Map user to regcenter
1. Run  
```sh
python lib/map_user_regcenter.py --help
```

