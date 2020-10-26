#!/bin/python3

import sys
sys.path.insert(0, '../')
from utils import *
from api import *
from keycloak import *
import config as conf
import csv

CSV_USERS = 'data/users.csv'

class App:
    def __init__(self, conf):
        self.mosip = MosipSession(conf.server, conf.user, conf.password)
        self.keycloak = KeycloakSession(conf.server, 'admin', 'admin')

    def create_users(self, csv_file):
        reader = csv.DictReader(open(csv_file, 'rt')) 
        for row in reader:
            print('Keycloak: Creating user %s' % row['name'])
            r =  self.keycloak.create_user(row['realm_id'], row['name'], row['pwd'], row['email'], 
                                           row['first_name'], row['last_name']) 
            if r.status_code == 409:  # Use already exits, then update
                print('Keycloak: User %s already exists. Updating.' % row['name'])
                r = self.keycloak.get_user(row['realm_id'], row['name'])  # Get user by username
                r = response_to_json(r) 
                user_id = r[0]['id']
                r =  self.keycloak.update_user(row['realm_id'], row['name'], row['pwd'], row['email'], 
                                              row['first_name'], row['last_name'], user_id) 
            elif r.status_code != 201:
                print_response(r)

def main():

    app = App(conf) 

    app.create_users(CSV_USERS)


if __name__=="__main__":
    main()
