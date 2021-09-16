#!/usr/local/bin/python3
# Script to logout a given user (given by user name)

import os
import sys
import ast
import argparse
import secrets
import json
import yaml
import traceback
from keycloak import KeycloakAdmin
from keycloak.exceptions import raise_error_from_response, KeycloakError
from keycloak.connection import  ConnectionManager
from keycloak.urls_patterns import URL_ADMIN_USER_REALM_ROLES

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('server_url', type=str, help='Keycloak server url. Eg. https://iam.xyz.com')  
   parser.add_argument('admin_user', type=str, help='Admin user')
   parser.add_argument('admin_password', type=str, help='Admin password')
   parser.add_argument('client_name', type=str, help='Name of the client that needs to be logged out')
   parser.add_argument('realm', type=str, help='Realm of client')
   parser.add_argument('--disable_ssl_verify', help='Disable ssl cert verification while connecting to server', action='store_true')
   args = parser.parse_args()
   return args

def main():

    args =  args_parse()
    ssl_verify = True
    if args.disable_ssl_verify:
        ssl_verify = False

    server_url = args.server_url + '/auth/' # Full url to access api 
    try:
        keycloak_admin = KeycloakAdmin(server_url=server_url,
                                       username=args.admin_user,
                                       password=args.admin_password,
                                       realm_name='master',
                                       verify=ssl_verify)
        keycloak_admin.realm_name = args.realm
        client_id = keycloak_admin.get_client_id(args.client_name)
        user = keycloak_admin.get_client_service_account_user(client_id)
        r = keycloak_admin.logout(user['id'])
        print(r)
    except:
        formatted_lines = traceback.format_exc()
        print(formatted_lines)
        sys.exit(1)

    print('Done')
    sys.exit(0)

if __name__=="__main__":
    main()

