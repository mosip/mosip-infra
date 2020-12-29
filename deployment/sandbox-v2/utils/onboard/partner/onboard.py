#!/bin/python3

import sys
import argparse
from api import *
import json
import config as conf
sys.path.insert(0, '../')
from utils import *

def add_partner(files):
    session = MosipSession(conf.server, conf.partner_user, conf.partner_pwd, 'partner', ssl_verify=conf.ssl_verify)
    for f in files:
        j = json.load(open(f, 'rt')) 
        myprint('Adding partner %s' % j['name'])
        r = session.add_partner(j['name'], j['contact'], j['address'], j['email'], j['id'], j['partner_type'], 
                                j['policy_group'])
        myprint(r)

def add_policy_group(files):
    session = MosipSession(conf.server, conf.policym_user, conf.policym_pwd, 'partner', ssl_verify=conf.ssl_verify)
    for f in files:
        j = json.load(open(f, 'rt')) 
        myprint('Adding policy group %s' % j['name'])
        r = session.add_policy_group(j['name'], j['description'])
        myprint(r)
        if len(r['errors']) > 0:  
            if r['errors'][0]['errorCode'] == 'PMS_POL_014': # Policy group already exists
                continue

def get_policy_group_id(policy_group_name):
        session = MosipSession(conf.server, conf.policym_user, conf.policym_pwd, 'partner', ssl_verify=conf.ssl_verify)
        r = session.get_policy_groups() 
        policy_groups = r['response']
        pg_id = None
        for pg in policy_groups:
             if pg['policyGroup']['name'] == policy_group_name:
                 pg_id = pg['policyGroup']['id']
                 break 
        return pg_id

def get_policy_id(policy_name):
    session = MosipSession(conf.server, conf.policym_user, conf.policym_pwd, 'partner', ssl_verify=conf.ssl_verify)
    r = session.get_policies() 
    policies =  r['response']
    policy_id = None
    for policy in policies:
        if policy['policyName'] == policy_name:
            policy_id = policy['policyId']
    return policy_id

def add_policy(files):
    session = MosipSession(conf.server, conf.policym_user, conf.policym_pwd, 'partner', ssl_verify=conf.ssl_verify)
    for f in files:
        j  = json.load(open(f, 'rt'))
        policies = j['policies']
        policy_group =  j['policy_group']
        for policy in policies:
            myprint('Adding policy "%s"' % policy['name'])
            policy_file = json.load(open(policy['policy_file'], 'rt'))
            r = session.add_policy(policy['policy_id'], policy['name'], policy['description'], 
                                   policy_file['policy_def'], policy_group, policy_file['policy_type'])
            myprint(r)
            if len(r['errors']) == 0:  
                policy_id = r['response']['id']
            else:
                if r['errors'][0]['errorCode'] == 'PMS_POL_009':  # Policy exists
                    myprint('Updating policy "%s"' % policy['name'])
                    policy_id = get_policy_id(policy['name'])
                    if policy_id is None:
                        myprint('Policy id for policy "%s" could not be found, skipping..' % policy['name'])
                        continue
                    r = session.update_policy(policy['name'], policy['description'], policy_file['policy_def'], 
                                              policy_group, policy_file['policy_type'], policy_id)
                    myprint(r) 
                else:
                    continue  # Can't do much
            
            # publish policy 
            myprint('Getting policy group id for policy group "%s"' % policy_group)
            pg_id = get_policy_group_id(policy_group)
            if pg_id is None:
                myprint('Could not find id for policy group "%s"' % (policy_group))
                continue
            myprint('Publishing policy "%s"' % policy['name'])
            r = session.publish_policy(pg_id, policy_id)
            myprint(r)

def upload_ca_certs(files):
    session = MosipSession(conf.server, conf.partner_manager_user, conf.partner_manager_pwd, 'partner', 
                           ssl_verify=conf.ssl_verify)
    for f in files:
        j  = json.load(open(f, 'rt'))
        ca_cert_path = j['cert']['ca_cert_path']
        myprint('Uploading CA certificate "%s"' % ca_cert_path)
        cert_data = open(ca_cert_path, 'rt').read()
        r = session.upload_ca_certificate(cert_data, j['partner_domain'])
        myprint(r)

def upload_partner_certs(files):
    session = MosipSession(conf.server, conf.partner_user, conf.partner_pwd, 'partner', ssl_verify=conf.ssl_verify,
                           client_token=True)
    for f in files:
        j  = json.load(open(f, 'rt'))
        myprint('Uplading partner certificate for "%s"' % j['name'])
        cert_data = open(j['cert']['cert_path'], 'rt').read()
        r = session.upload_partner_certificate(cert_data, j['name'], j['partner_domain'], j['id'], j['partner_type'])
        myprint(r)
        mosip_signed_cert_path = os.path.join(os.path.dirname(j['cert']['cert_path']), 'mosip_signed_cert.pem')
        if r['errors'] is None:
            mosip_signed_cert = r['response']['signedCertificateData']
            open(mosip_signed_cert_path, 'wt').write(mosip_signed_cert)
            myprint('MOSIP signed certificate saved as %s' % mosip_signed_cert_path)

def map_partner_policy(files):
    session1 = MosipSession(conf.server, conf.partner_user, conf.partner_pwd, 'partner', ssl_verify=conf.ssl_verify)
    session2 = MosipSession(conf.server, conf.partner_manager_user, conf.partner_manager_pwd, 'partner', 
                            ssl_verify=conf.ssl_verify)
    for f in files:
        j  = json.load(open(f, 'rt'))
        policies = j['policies']
        for policy in policies:
            myprint('Getting policies for a partner "%s" to check if this is a duplicate entry' % j['id']) 
            r = session1.get_partner_api_key_requests(j['id'])
            myprint(r)
            if r['errors'] is not None:  
                if r['errors']['errorCode'] == 'PMS_PRT_005':  # Partner does not exist, add only then
                    myprint('Sending partner-policy mapping request for (PARTNER: %s, POLICY: %s)' % (j['id'], 
                              policy['name']))
                    r = session1.add_partner_api_key_requests(j['id'], policy['name'], policy['description'])
                    myprint(r)
                    api_request_id = r['response']['apiRequestId']
            
                    # Approve
                    myprint('Approving request for (PARTNER: %s, POLICY: %s)' % (j['id'], policy['name']))
                    r =  session2.approve_partner_policy(api_request_id, 'Approved')
                    myprint(r)
            else:
                if r['response'][0]['apiKeyRequestStatus'] == 'In-Progress':
                    api_request_id = r['response'][0]['apiKeyReqID']
                    myprint('Approving request for (PARTNER: %s, POLICY: %s)' % (j['id'], policy['name']))
                    r =  session2.approve_partner_policy(api_request_id, 'Approved')
                    myprint(r)
                else:
                    myprint('ERROR: Skipping..')
                    continue

def create_misp(files):
    session = MosipSession(conf.server, conf.misp_user, conf.misp_pwd, 'partner', ssl_verify=conf.ssl_verify)
    for f in files:
        j  = json.load(open(f, 'rt'))
        myprint('Creating MISP "%s"' % j['name'])
        r = session.create_misp(j['name'], j['address'], j['contact'], j['email'])
        myprint(r)
        if len(r['errors']) == 0:   # No error
            misp_id = r['response']['mispID']
        else: 
            myprint('Get misp id for "%s"' % j['name'])
            if r['errors'][0]['errorCode'] == 'PMS_MSP_003':  # Already exists 
                r = session.get_misps() 
                misps = r['response'] 
                for misp in misps:
                    myprint(misp)
                    if misp['misp']['name'] == j['name']:
                        misp_id = misp['misp']['ID']
            else:
               continue # Can't do much but to myprint error 
        # Approving 
        myprint('Approving MISP "%s"' % j['name'])
        r = session.approve_misp(misp_id, 'approved')
        myprint(r)

def add_extractor(files):
    session = MosipSession(conf.server, conf.partner_user, conf.partner_pwd, ssl_verify=conf.ssl_verify)
    for f in files:
        j  = json.load(open(f, 'rt'))
        policies = j['policies']
        for policy in policies:
            myprint('Adding extractors for %s -- %s' % (j['id'], policy['policy_id']))
            extractors = policy['extractors']
            for extractor in extractors:
                r = session.add_extractor(j['id'], policy['policy_id'], extractor['attribute'], extractor['biometric'], 
                                          extractor['provider'], extractor['version'])
                myprint(r)

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('action', help='policy_group|policy|extractor|partner|upload_certs|partner_policy|misp|all. For policy specify partner json (not a policy json) ') 
   parser.add_argument('path', help='directory or file containing input data json')
   parser.add_argument('--server', type=str, help='Full url to point to the server.  Setting this overrides server specified in config.py')
   parser.add_argument('--disable_ssl_verify', help='Disable ssl cert verification while connecting to server', action='store_true')
   args = parser.parse_args()
   return args, parser

def main():
    args, parser =  args_parse() 

    if args.server:
        conf.server = args.server   # Overide

    if args.disable_ssl_verify:
        conf.ssl_verify = False

    files = path_to_files(args.path)

    init_logger('./out.log')
    try:
        if args.action == 'policy_group' or args.action == 'all':
            add_policy_group(files)
        if args.action == 'policy' or args.action == 'all':
            add_policy(files)
        if args.action == 'partner' or args.action == 'all':
            add_partner(files)
        if args.action == 'extractor' or args.action == 'all':
            add_extractor(files)
        if args.action == 'upload_certs' or args.action == 'all':
            upload_ca_certs(files)
            upload_partner_certs(files) #TODO: make sure  key_alias.py is called below api
        if args.action == 'partner_policy' or args.action == 'all':   
            map_partner_policy(files)
        if args.action == 'misp'or args.action == 'all':
            create_misp(files)
    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    return sys.exit(0)

if __name__=="__main__":
    main()
