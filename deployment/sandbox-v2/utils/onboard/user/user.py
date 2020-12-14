#!/bin/python3

import sys
from api import *
import traceback
import argparse
import csv
import config as conf
sys.path.insert(0, '../')
from utils import *

def create_users_in_keycloak(csv_file):
    session = KeycloakSession(conf.server, conf.keycloak_admin, conf.keycloak_pwd, conf.ssl_verify)
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        myprint('Keycloak: Creating user "%s"' % row['name'])
        r =  session.create_user(row['realm_id'], row['name'], row['pwd'], row['email'], row['first_name'], 
                                 row['last_name'], row['rid']) 
        if r.status_code == 409:  # Use already exits, then update
            myprint('Keycloak: User "%s" already exists. Updating.' % row['name'])
            user_id = session.get_user(row['realm_id'], row['name'])  # Get user by username
            r =  session.update_user(row['realm_id'], row['name'], row['pwd'], row['email'], row['first_name'], 
                                     row['last_name'], user_id, row['rid']) 
        elif r.status_code != 201:
            myprint_response(r)
            break 

        # Map role
        for role in row['roles'].split():
            myprint('Keycloak: Mapping role %s to user "%s"' % (role, row['name']))
            user_id = session.get_user(row['realm_id'], row['name'])  # Get user by username
            r = session.get_role(row['realm_id'], role)
            role_json = response_to_json(r) 
            r = session.map_user_role(row['realm_id'], user_id, role_json)
            if r.status_code != 204:
                myprint_response(r)
                break

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('--server', type=str, help='Full url to point to the server.  Setting this overrides server specified in config.py')
   parser.add_argument('--disable_ssl_verify', help='Disable ssl cert verification while connecting to server', action='store_true')
   parser.add_argument('action', help='keycloak|masterdb|all')
   args = parser.parse_args()
   return args

def main():


    args =  args_parse() 
    if args.server:
        conf.server = args.server   # Overide

    if args.disable_ssl_verify:
        conf.ssl_verify = False

    init_logger('./out.log')

    try:
        if args.action == 'keycloak' or args.action == 'all':
            r = create_users_in_keycloak(conf.csv_users)
    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    sys.exit(r)

if __name__=="__main__":
    main()
