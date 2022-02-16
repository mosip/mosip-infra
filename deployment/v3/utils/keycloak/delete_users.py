#!/usr/local/bin/python3
# Script to create users in Keycloak with roles.  Input is provided using a YAML.

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

def delete_user(session, realm, uname):
    session.realm_name = realm
    try:
        print('Deleting user %s' % uname)
        user_id = session.get_user_id(uname)
        session.delete_user(user_id)
    except KeycloakError as e:
        if e.response_code == 404:
            print('User %s not found' % uname)
    except:
        session.realm_name = 'master' # restore
        raise

    session.realm_name = 'master' # restore

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('server_url', type=str, help='Keycloak server url. Eg. https://iam.xyz.com')  
   parser.add_argument('admin_user', type=str, help='Admin user')
   parser.add_argument('admin_password', type=str, help='Admin password')
   parser.add_argument('input_yaml', type=str, help='File containing users to be deleted in YAML format')
   parser.add_argument('--disable_ssl_verify', help='Disable ssl cert verification while connecting to server', action='store_true')
   args = parser.parse_args()
   return args

def main():

    args =  args_parse()
    ssl_verify = True
    if args.disable_ssl_verify:
        ssl_verify = False

    server_url = args.server_url + '/auth/' # Full url to access api 
    fp = open(args.input_yaml, 'rt')
    values = yaml.load(fp, Loader=yaml.FullLoader)
    try:
        session = KeycloakAdmin(server_url=server_url,
                                username=args.admin_user,
                                password=args.admin_password,
                                realm_name='master',
                                verify=ssl_verify)
        for realm in values:
            users = values[realm]['users']
            for user in users:
                r = delete_user(session, realm, user['username'])
    except:
        formatted_lines = traceback.format_exc()
        print(formatted_lines)
        sys.exit(1)

    sys.exit(r)

if __name__=="__main__":
    main()

