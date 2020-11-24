#!/bin/python3
# This script adds users in Keycloak
# Set config.py
# Usage: ./keycloak_users.py

import sys
sys.path.insert(0, '../')
from utils import *
from keycloak_api import *
import config as conf
import csv

class App:
    def __init__(self, conf):
        self.keycloak = KeycloakSession(conf.server, conf.keycloak_admin_user, conf.keycloak_admin_pwd) 

    def create_users_in_keycloak(self, csv_file):
        reader = csv.DictReader(open(csv_file, 'rt')) 
        for row in reader:
            print('Keycloak: Creating user "%s"' % row['name'])
            r =  self.keycloak.create_user(row['realm_id'], row['name'], row['pwd'], row['email'], 
                                           row['first_name'], row['last_name']) 
            if r.status_code == 409:  # Use already exits, then update
                print('Keycloak: User "%s" already exists. Updating.' % row['name'])
                user_id = self.keycloak.get_user(row['realm_id'], row['name'])  # Get user by username
                r =  self.keycloak.update_user(row['realm_id'], row['name'], row['pwd'], row['email'], 
                                              row['first_name'], row['last_name'], user_id) 
            elif r.status_code != 201:
                print_response(r)
                break 

            # Map role
            for role in row['roles'].split():
                print('Keycloak: Mapping role %s to user "%s"' % (role, row['name']))
                user_id = self.keycloak.get_user(row['realm_id'], row['name'])  # Get user by username
                r = self.keycloak.get_role(row['realm_id'], role)
                role_json = response_to_json(r) 
                r = self.keycloak.map_user_role(row['realm_id'], user_id, role_json)
                if r.status_code != 204:
                    print_response(r)
                    break

def main():

    app = App(conf) 

    app.create_users_in_keycloak(conf.csv_users)


if __name__=="__main__":
    main()
