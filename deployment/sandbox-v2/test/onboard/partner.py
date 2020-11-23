#!/bin/python3

import sys
import argparse
from partner_api import *
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

def get_policy_group_id(policy_group_name):
        session = MosipSession(conf.server, conf.policym_user, conf.policym_pwd, 'partner')
        r = session.get_policy_groups() 
        r = response_to_json(r)
        policy_groups = r['response']
        pg_id = None
        for pg in policy_groups:
             if pg['policyGroup']['name'] == policy_group_name:
                 pg_id = pg['policyGroup']['id']
                 break 
        return pg_id

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
        if len(r['errors']) == 0:  
            policy_id = r['response']['id']
        else:
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
        
        # publish policy 
        print('Getting policy group id for policy group "%s"' % row['policy_group'])
        pg_id = get_policy_group_id(row['policy_group'])
        if pg_id is None:
            print('Could not find id for policy group "%s"' % (row['policy_group']))
            continue
        print('Publishing policy "%s"' % row['name'])
        r = session.publish_policy(pg_id, policy_id)
        r = response_to_json(r) 
        print(r)

def upload_ca_certs(csv_file):
    session = MosipSession(conf.server, conf.partner_manager_user, conf.partner_manager_pwd, 'partner')
    
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        print('Uploading CA certificate "%s"' % row['ca_cert_path'])
        cert_data = open(row['ca_cert_path'], 'rt').read()
        r = session.upload_ca_certificate(cert_data, row['partner_domain'])
        r = response_to_json(r)
        print(r)

def upload_partner_certs(csv_file):
    session = MosipSession(conf.server, conf.partner_user, conf.partner_pwd, 'partner')
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        print('Uplading partner certificate for "%s"' % row['org_name'])
        cert_data = open(row['cert_path'], 'rt').read()
        r = session.upload_partner_certificate(cert_data, row['org_name'], row['partner_domain'], row['partner_id'],
                                               row['partner_type'])
        r = response_to_json(r)
        print(r)
        
def map_partner_policy(csv_file):
    session1 = MosipSession(conf.server, conf.partner_user, conf.partner_pwd, 'partner')
    session2 = MosipSession(conf.server, conf.partner_manager_user, conf.partner_manager_pwd, 'partner')
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        print('Sending partner-policy mapping request for %s-%s' % (row['partner_id'], row['policy_name']))
        r = session1.add_partner_api_key_requests(row['partner_id'], row['policy_name'], row['description'])
        r = response_to_json(r)
        print(r)
        api_request_id = r['response']['apiRequestId']

        # Approve the same
        print('Approving request for %s-%s' % (row['partner_id'], row['policy_name']))
        r =  session2.approve_partner_policy(api_request_id, 'Approved')
        r = response_to_json(r)
        print(r)

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('action', help='policy_group|policy|partner|certs|partner_policy') 
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
    if args.action == 'certs':
        upload_ca_certs(conf.csv_partner_ca_certs) 
        # TODO: make sure you've called key_alias.py before calling below api
        upload_partner_certs(conf.csv_partner_certs)
    if args.action == 'partner_policy':    
        map_partner_policy(conf.csv_partner_policy_map)
        
 

if __name__=="__main__":
    main()
