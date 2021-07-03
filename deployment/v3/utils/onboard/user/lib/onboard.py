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

def get_user_id(realm, username, session):
    '''
    Note that GET api returns all usernames which substring username
    '''
    users  = session.get_user(realm, username)
    user_id = None 
    for user in users: 
        if user['username'] == username: 
            user_id = user['id']
            break 
    return user_id

def create_users_in_keycloak(files):
    session = KeycloakSession(conf.server, conf.keycloak_admin, conf.keycloak_pwd, conf.ssl_verify)
    for f in files:
        j  = json.load(open(f, 'rt'))
        myprint('Keycloak: Creating user "%s"' % j['username'])
        r =  session.create_user(j['realm_id'], j['username'], j['pwd'], j['email'], j['first_name'], 
                                 j['last_name'], j['rid']) 
        if r.status_code == 409:  # User already exits, then update
            myprint('Keycloak: User "%s" already exists. Updating.' % j['username'])
            user_id = get_user_id(j['realm_id'], j['username'], session) 
            r =  session.update_user(j['realm_id'], j['username'], j['pwd'], j['email'], j['first_name'], 
                                     j['last_name'], user_id, j['rid']) 
            if r.status_code != 204:
                myprint(r.content)
        elif r.status_code != 201:
            myprint(r.content)
            break 

        # Map role
        for role in j['roles']:
            myprint('Keycloak: Mapping role %s to user "%s"' % (role, j['username']))
            user_id = get_user_id(j['realm_id'], j['username'], session)  
            role_json = session.get_role(j['realm_id'], role)
            r = session.map_user_role(j['realm_id'], user_id, role_json)
            if r.status_code != 204:
                myprint(r.content)
                break

def create_clients_in_keycloak(files):
    session = KeycloakSession(conf.server, conf.keycloak_admin, conf.keycloak_pwd, conf.ssl_verify)
    for f in files:
        j  = json.load(open(f, 'rt'))
        myprint('Keycloak: Creating client "%s"' % j['client_id'])
        s = session.create_client(j['realm_id'], j['client_id'], j['name'], j['secret'], j['base_url'])
        
        if s.status_code == 409: # Client already exits, then update
            myprint('Keycloak: Client "%s" already exists. Updating.' % j['client_id'])
            client_id_info = session.get_client(j['realm_id'], j['client_id']) # Get client info id by client_id
            s = session.update_client(j['realm_id'], j['client_id'], j['name'], j['secret'], j['base_url'], 
                                      client_id_info)
            if s.status_code != 204:
                myprint(s.content)
        elif s.status_code != 201:
            myprint(s.content)
            break

def add_user_to_masterdb(files):
    db = DB(conf.db_user, conf.db_pwd, conf.db_host, conf.db_port, 'mosip_master') 
    for f in files:
        j  = json.load(open(f, 'rt'))
        myprint('Adding user %s in masterdb' % j['username'])
        db.insert_user_in_masterdb_sql(j['username'], j['first_name'] + ' ' + j['last_name'], j['regcntr_id'])
        myprint('Adding user-zone mapping for  %s in masterdb' % j['username'])
        db.insert_zone_user_map_in_masterdb_sql(j['username'], j['zone_id'])
    db.close()

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('action', help='keycloak|masterdb|all')
   parser.add_argument('path', help='directory or file containing input data jsons')
   parser.add_argument('--server', type=str, help='Full url to point to the server.  Setting this overrides server specified in config.py')
   parser.add_argument('--disable_ssl_verify', help='Disable ssl cert verification while connecting to server', action='store_true')
   args = parser.parse_args()
   return args

def main():
    args =  args_parse() 
    if args.server:
        conf.server = args.server   # Overide

    if args.disable_ssl_verify:
        conf.ssl_verify = False

    files = path_to_files(args.path)

    init_logger('full', 'a', './out.log', level=logging.INFO)  # Append mode
    init_logger('last', 'w', './last.log', level=logging.INFO, stdout=False)  # Just record log of last run

    try:
        if args.action == 'keycloak':
           r = create_users_in_keycloak(files)
#           s = create_clients_in_keycloak(files)
        if args.action == 'masterdb':
            add_user_to_masterdb(files)
    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    sys.exit(0)

if __name__=="__main__":
    main()
