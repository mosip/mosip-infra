# Keycloak utilities

Various Python based utilities for Keycloak.

## Prerequisites
1. Install python3.9 virtual env
1. Switch to virtual env 
1. Install required modules
```sh
pip install -r requirements.txt
```

## Client sessions logout
The script here logs out all the sessions of given client and realm.  This is useful in case several sessions have been created and we would like to kill all of them.

Run the script for all parameters needed:
```sh
python keycloak_logout.py --help
```
