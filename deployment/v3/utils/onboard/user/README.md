# User Onboarding

## Prerequisites
* Install python3.9 
* Create Python virtualenv
* Switch to virtualenv
* Install modules
```sh
pip install -f requirements.txt
```
* Make the users that are to be onboarded are present in Keycloak `mosip` realm.

## Map user-zone
User-zone mapping is required to access Admin portal.  Run the following for script arguments:
```sh
python lib/map_user_zone.py --help
```

## Map user-regcenter
A user like a registration officer needs to be mapped to a registration center. Run the following for script arguments:
```sh
python lib/map_user_regcenter.py --help
```
