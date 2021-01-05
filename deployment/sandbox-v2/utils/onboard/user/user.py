#!/bin/python3

import sys
import traceback
import argparse
import csv
import config as conf
from api import *
from db import *
sys.path.insert(0, '../')
from utils import *

def create_users_in_keycloak(csv_file):
    session = KeycloakSession(conf.server, conf.keycloak_admin, conf.keycloak_pwd, conf.ssl_verify)
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        myprint('Keycloak: Creating user "%s"' % row['user_id'])
        r =  session.create_user(row['realm_id'], row['user_id'], row['pwd'], row['email'], row['first_name'], 
                                 row['last_name'], row['rid']) 
        if r.status_code == 409:  # User already exits, then update
            myprint('Keycloak: User "%s" already exists. Updating.' % row['name'])
            user_id = session.get_user(row['realm_id'], row['user_id']) 
            r =  session.update_user(row['realm_id'], row['user_id'], row['pwd'], row['email'], row['first_name'], 
                                     row['last_name'], user_id, row['rid']) 
        elif r.status_code != 201:
            myprint_response(r)
            break 

        # Map role
        for role in row['roles'].split():
            myprint('Keycloak: Mapping role %s to user "%s"' % (role, row['user_id']))
            user_id = session.get_user(row['realm_id'], row['user_id'])  
            r = session.get_role(row['realm_id'], role)
            role_json = response_to_json(r) 
            r = session.map_user_role(row['realm_id'], user_id, role_json)
            if r.status_code != 204:
                myprint_response(r)
                break

def create_clients_in_keycloak(csv_file):
    session = KeycloakSession(conf.server, conf.keycloak_admin, conf.keycloak_pwd, conf.ssl_verify)
    reader = csv.DictReader(open(csv_file, 'rt'))
    for row in reader:
        myprint('Keycloak: Creating client "%s"' % row['client_id'])
        s = session.create_client(row['realm_id'], row['client_id'], row['name'], row['secret'], row['base_url'])
        
        if s.status_code == 409: # Client already exits, then update
            myprint('Keycloak: Client "%s" already exists. Updating.' % row['client_id'])
            client_id_info = session.get_client(row['realm_id'], row['client_id']) # Get client info id by client_id
            s=session.update_client(row['realm_id'], row['client_id'], row['name'], row['secret'],row['base_url'], client_id_info)

        elif s.status_code != 201:
            myprint_response(s)
            break

def add_user_to_masterdb(csv_file):
    db = DB(conf.db_user, conf.db_pwd, conf.db_host, conf.db_port, 'mosip_master') 
    reader = csv.DictReader(open(csv_file, 'rt'))
    for row in reader:
        myprint('Adding user %s in masterdb' % row['user_id'])
        db.insert_user_in_masterdb_sql(row['user_id'], row['first_name'] + ' ' + row['last_name'], row['regcntr_id'])
        myprint('Adding user-zone mapping for  %s in masterdb' % row['user_id'])
        db.insert_zone_user_map_in_masterdb_sql(row['user_id'], row['zone_id'])
    db.close()

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

    init_logger('full', 'a', './out.log', level=logging.INFO)  # Append mode
    init_logger('last', 'w', './last.log', level=logging.INFO, stdout=False)  # Just record log of last run

    try:
        if args.action == 'keycloak' or args.action == 'all':
            r = create_users_in_keycloak(conf.csv_users)
            s = create_clients_in_keycloak(conf.csv_clients)
        if args.action == 'masterdb' or args.action == 'all':
            add_user_to_masterdb(conf.csv_users)
    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    sys.exit(0)

if __name__=="__main__":
    main()
