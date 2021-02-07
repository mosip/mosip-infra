#!/bin/python3
# This script reads plain text secrets from Ansible secrets.yml file and uses config server
# to encrypt them.  The encrypted passwords are used in MOSIP config server config.

import argparse
import traceback
import sys
import copy
import yaml
import json
from ansible_vault import Vault
import config as conf
import requests
import getpass

def replace_values(d, server):
    nodes = d.keys()
    for node in nodes:
      subnode = d[node]
      if isinstance(subnode, dict):
        replace_values(subnode, server)
      else:
        if len(d[node]) > 0:
          d[node] = encrypt_using_config_server(d[node], server)

def encrypt_using_config_server(text, server):
   url = '%s/config/encrypt' % server
   headers = {'content-type': 'text/plain'}
   r = requests.post(url, data=text, headers=headers, verify=conf.ssl_verify)
   return r.content.decode() # binary --> str

def read_secrets(secrets_file):
   p = getpass.getpass()
   vault = Vault(p) 
   secrets = vault.load(open(secrets_file).read())
   return secrets
 
def dict_to_yaml(d, out_file): 
    f = open(out_file, 'wt')
    yaml.dump(d, f, allow_unicode=True, sort_keys=False)

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('secrets', type=str,  help='Ansible secrets file')
   args = parser.parse_args()
   return args, parser

def main():
    args, parser =  args_parse() 
    secrets_file = args.secrets 
    try:
       secrets = read_secrets(secrets_file)
       replace_values(secrets, conf.server)
       dict_to_yaml(secrets, 'out.yaml')
    except:
        formatted_lines = traceback.format_exc()
        print(formatted_lines)
        sys.exit(1)

    sys.exit(0)

if __name__=="__main__":
    main()
