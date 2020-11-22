#!/bin/python3

import sys
import argparse
from api import *
import csv
import json
import config as conf
sys.path.insert(0, '../')
from utils import *

def add_partner(csv_file,):
    session = MosipSession(conf.server, conf.partner_user, conf.partner_pwd, 'partner')
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        print('Adding partner %s' % row['name'])
        r = session.add_partner(row['name'], row['contact'], row['address'], row['email'], row['id'], 
                                    row['type'], row['policy_group'])
        r = response_to_json(r)
        print(r)

def add_policy_group(csv_file):
    session = MosipSession(conf.server, conf.policym_user, conf.policym_pwd, 'partner')
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        print('Adding policy group %s' % row['name'])
        r = session.add_policy_group(row['name'], row['description'])
        if r.status_code == 200: 
            continue
        r = response_to_json(r)
        print(r)

def add_policy(csv_file):
    session = MosipSession(conf.server, conf.policym_user, conf.policym_pwd, 'partner')
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        print('Adding policy "%s"' % row['name'])
        json_str = open(row['policy_file'], 'rt').read() 
        policy = json.loads(json_str)  
        r = session.add_policy(row['name'], row['description'], policy, row['policy_group'], row['policy_type'])
        r = response_to_json(r)
        print(r)
        if r['errors'][0]['errorCode'] == 'PMS_POL_009':  # Policy exists
            print('Updating policy "%s"' % row['name'])
            r = session.get_policies() 
            r = response_to_json(r)
            policies =  r['response']
            policy_id = None
            for policy in policies:
                if policy['policyName'] == row['name']:
                    policy_id = policy['policyId']
            if policy_id is None:
                print('Policy id for policy "%s" could not be found, skipping..' % row['name'])
                continue
            r = session.update_policy(row['name'], row['description'], policy, row['policy_group'], row['policy_type'],
                                     policy_id)
            r = response_to_json(r)
            print(r) 

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('action', help='policy_group|partner|policy') 
   args = parser.parse_args()
   return args

def main():

    args = args_parse()

    if args.action == 'policy_group':
        add_policy_group(conf.csv_policy_group)
    if args.action == 'policy':
        add_policy(conf.csv_policy)
    if args.action == 'partner':
        add_partner(conf.csv_partner)

if __name__=="__main__":
    main()
