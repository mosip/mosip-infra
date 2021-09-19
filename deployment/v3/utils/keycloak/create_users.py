#!/usr/local/bin/python3
# Script to create users in Keycloak with roles.  Input is provided using a YAML.

import os
import sys
import ast
import argparse
import secrets
import json
import string
import yaml
import random
import traceback
from keycloak import KeycloakAdmin
from keycloak.exceptions import raise_error_from_response, KeycloakError
from keycloak.urls_patterns import URL_ADMIN_USER_REALM_ROLES

def generate_random_password(length):
    characters = list(string.ascii_letters + string.digits + "!@#$%^&*()")
    special = "!@#$%^&*()"
    alphabet = string.ascii_letters + string.digits + special
    while True:
        password = ''.join(secrets.choice(alphabet) for i in range(length))
        if (any(c.islower() for c in password) and 
            any(c.isupper() for c in password) and 
            any(c.isdigit() for c in password) and
            any(c in special for c in password)):
            break
    return password

def create_user(session, realm, uname, email, fname, lname, password, temp_flag):
    session.realm_name = realm
    payload = {
      "username" : uname,
      "email" : email,
      "firstName" : fname,
      "lastName" : lname,
      "enabled": True
    }
    try:
        print('Creating user %s' % uname)
        session.create_user(payload, False) # If exists, update. So don't skip
        user_id = session.get_user_id(uname)
        session.set_user_password(user_id, password, temporary=temp_flag)
    except KeycloakError as e:
        if e.response_code == 409:
            print('Exists, updating %s' % uname)
            user_id = session.get_user_id(uname)
            session.update_user(user_id, payload)
    except:
        session.realm_name = 'master' # restore
        raise

    session.realm_name = 'master' # restore

def assign_user_roles(session, realm, uname, roles):
    session.realm_name = realm
    print('Assign roles to user %s' % uname)
    try:
        user_id = session.get_user_id(uname)
        role_reps = []
        for role in roles:
            role_rep = session.get_realm_role(role)
            role_reps.append(role_rep)
        params_path = {"realm-name": session.realm_name, "id": user_id}
        session.raw_post(URL_ADMIN_USER_REALM_ROLES.format(**params_path), data=json.dumps(role_reps))
    except:
        session.realm_name = 'master' # restore
        raise
    session.realm_name = 'master' # restore

def is_password_empty(var):
   if type(var) == str:
       if len(var.strip()) == 0:
          return True
   elif var is None:
       return True
   else:
      return False 

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('server_url', type=str, help='Keycloak server url. Eg. https://iam.xyz.com')  
   parser.add_argument('admin_user', type=str, help='Admin user')
   parser.add_argument('admin_password', type=str, help='Admin password')
   parser.add_argument('input_yaml', type=str, help='File containing input for user and their roles in YAML format')
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
                password =  user['password']
                if is_password_empty(password):
                    password = generate_random_password(10) 
                r = create_user(session, realm, user['username'], user['email'], user['firstName'], user['lastName'], 
                                password, user['temporary'])
                print('*** User: %s, password: %s' % (user['username'], password))
                # Assign role
                assign_user_roles(session, realm, user['username'], user['roles'])
    except:
        formatted_lines = traceback.format_exc()
        print(formatted_lines)
        sys.exit(1)

    sys.exit(r)

if __name__=="__main__":
    main()

