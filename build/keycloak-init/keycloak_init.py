#!/usr/local/bin/python3
# Script to initialize values in Keycloak

import sys
import ast
import argparse
import json
import yaml
import traceback
from keycloak import KeycloakAdmin
from keycloak.exceptions import KeycloakGetError
from keycloak.exceptions import raise_error_from_response, KeycloakGetError
from keycloak.connection import  ConnectionManager

class KeycloakSession:
    def __init__(self, realm, server_url, user, pwd, ssl_verify):
        self.keycloak_admin = KeycloakAdmin(server_url=server_url,
                                            username=user,
                                            password=pwd,
                                            realm_name=realm,
                                            verify=ssl_verify)
    def create_realm(self, realm):
        payload = {
            "realm" : realm,
            "enabled": True,
            "accessCodeLifespan": 7200,
            "accessCodeLifespanLogin": 1800,
            "accessCodeLifespanUserAction": 300,
            "accessTokenLifespan": 86400,
            "accessTokenLifespanForImplicitFlow": 900,
            "actionTokenGeneratedByAdminLifespan": 43200,
            "actionTokenGeneratedByUserLifespan": 300
        }
        try:
            self.keycloak_admin.create_realm(payload, skip_exists=False)
        except KeycloakGetError as e:
            if e.response_code == 409:
                print('Exists, updating %s' % realm)
                self.keycloak_admin.update_realm(realm, payload)
        except:
            raise

        return 0

    def create_role(self, realm, role):
        print('Creating role %s for realm %s'  % (role, realm))
        self.keycloak_admin.realm_name = realm  # work around because otherwise role was getting created in master
        self.keycloak_admin.create_realm_role({'name' : role, 'clientRole' : False}, skip_exists=True)
        self.keycloak_admin.realm_name = 'master' # restore
        return 0

    def create_client(self, realm, client, secret):
        self.keycloak_admin.realm_name = realm  # work around because otherwise role was getting created in master
        payload = {
          "clientId" : client,
          "secret" : secret
        }
        try:
            self.keycloak_admin.create_client(payload, skip_exists=False)  # If exists, update. So don't skip
        except KeycloakGetError as e:
            if e.response_code == 409:
                print('Exists, updating %s' % client)
                self.keycloak_admin.update_client(client, payload)
        except:
            self.keycloak_admin.realm_name = 'master' # restore
            raise
        self.keycloak_admin.realm_name = 'master' # restore

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('server_url', type=str, help='Full url to point to the server for auth: Eg. https://iam.xyz.com/auth/.  Note: slash is important')  
   parser.add_argument('user', type=str, help='Admin user')
   parser.add_argument('password', type=str, help='Admin password')
   parser.add_argument('input_yaml', type=str, help='File containing input for roles and clients in YAML format')
   parser.add_argument('--disable_ssl_verify', help='Disable ssl cert verification while connecting to server', action='store_true')
   args = parser.parse_args()
   return args

def main():

    args =  args_parse()
    server_url = args.server_url 
    user = args.user
    password = args.password
    input_yaml = args.input_yaml

    ssl_verify = True
    if args.disable_ssl_verify:
        ssl_verify = False

    fp = open(input_yaml, 'rt')
    values = yaml.load(fp, Loader=yaml.FullLoader)
    try:
        print('Create realms')
        ks = KeycloakSession('master', server_url, user, password, ssl_verify)
        for realm in values:
            r = ks.create_realm(realm)  # {realm : [role]}

        for realm in values:
            ks = KeycloakSession('master', server_url, user, password, ssl_verify)
            print('Create roles for realm %s' % realm) 
            roles = values[realm]['roles']
            for role in roles:
                r = ks.create_role(realm, role)

            clients = values[realm]['clients']
            for client in clients:
              r = ks.create_client(realm, client['name'], client['secret'])  

    except:
        formatted_lines = traceback.format_exc()
        print(formatted_lines)
        sys.exit(1)

    sys.exit(r)

if __name__=="__main__":
    main()

