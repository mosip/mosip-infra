#!/bin/python3

import sys
import argparse
from api import *
import json
import config as conf
sys.path.insert(0, '../')
from utils import *

def get_partner_policy_group(partner_dict):
    '''
    A partner can belong to one policy_group.  Here, we are picking up policy_group from policies
    defined for the partner.  If there are multiple policies for the partner then it is assumed
    that all the policies belong to the same group.  So any one of the policy_group is picked.
    '''
    policy_group = ''
    if len(partner_dict['policies']) > 0:
        policy = partner_dict['policies'][0] 
        j = json.load(open(policy['policy_file'], 'rt'))
        policy_group = j['policy_group'] 
    return policy_group

def add_partner(files):
    session = MosipSession(conf.server, conf.partner_user, conf.partner_pwd, 'partner', ssl_verify=conf.ssl_verify)
    for f in files:
        j = json.load(open(f, 'rt')) 
        myprint('Adding partner %s' % j['name'])
        policy_group = get_partner_policy_group(j)
        r = session.add_partner(j['name'], j['contact'], j['address'], j['email'], j['id'], j['partner_type'], 
                                policy_group)
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
        myprint('Adding policy "%s"' % j['name'])
        r = session.add_policy(j['id'], j['name'], j['description'], j['def'], j['policy_group'], j['type'])
        myprint(r)
        if len(r['errors']) == 0:  
            policy_id = r['response']['id']
        else:
            if r['errors'][0]['errorCode'] == 'PMS_POL_009':  # Policy exists
                myprint('Updating policy "%s"' % j['name'])
                policy_id = get_policy_id(j['name'])
                if policy_id is None:
                    myprint('Policy id for policy "%s" could not be found, skipping..' % j['name'])
                    continue
                r = session.update_policy(j['name'], j['description'], j['def'], j['policy_group'], j['type'], 
                                          policy_id)
                myprint(r) 
            else:
                continue  # Can't do much
        
        # publish policy 
        myprint('Getting policy group id for policy group "%s"' % j['policy_group'])
        pg_id = get_policy_group_id(j['policy_group'])
        if pg_id is None:
            myprint('Could not find id for policy group "%s"' % (j['policy_group']))
            continue
        myprint('Publishing policy "%s"' % j['name'])
        r = session.publish_policy(pg_id, policy_id)
        myprint(r)

def upload_ca_cert(path, partner_domain):
    session = MosipSession(conf.server, conf.partner_manager_user, conf.partner_manager_pwd, 'partner', 
                           ssl_verify=conf.ssl_verify)
    myprint('Uploading CA certificate "%s"' % path)
    cert_data = open(path, 'rt').read()
    r = session.upload_ca_certificate(cert_data, partner_domain)
    myprint(r)

def upload_partner_cert(path, partner_name, partner_id, partner_domain, partner_type):
    session = MosipSession(conf.server, conf.partner_user, conf.partner_pwd, 'partner', ssl_verify=conf.ssl_verify,
                           client_token=False)
    myprint('Uplading partner certificate "%s"' % path)
    cert_data = open(path, 'rt').read()
    r = session.upload_partner_certificate(cert_data, partner_name, partner_domain, partner_id, partner_type)
    myprint(r)
    mosip_signed_cert_path = os.path.join(os.path.dirname(path), 'mosip_signed_cert.pem')
    if r['errors'] is None:
        mosip_signed_cert = r['response']['signedCertificateData']
        open(mosip_signed_cert_path, 'wt').write(mosip_signed_cert)
        myprint('MOSIP signed certificate saved as %s' % mosip_signed_cert_path)

def order_certs(cert_jsons):
    '''
    Order the input cert files based on which ones need to be created first based on interdepedencies.
    '''
    first, second, third = [], [], []
    for f in cert_jsons:
        j = json.load(open(f, 'rt'))
        ca_path = j['ca_cert'].strip()
        if j['is_ca'] and ca_path: # root cert
            first.append(f)
        elif j['is_ca'] and not ca_path: # dependent root cert
            second.append(f)
        else:
            third.append(f)
    ordered = first + second + third
    return ordered

def upload_certs(partner_jsons):
    for f in partner_jsons: 
        j = json.load(open(f, 'rt'))
        certs = j['certs']
        certs = order_certs(certs)
        for cert in certs: 
            c = json.load(open(cert, 'rt'))
            cert_path = c['cert_path']
            if c['is_ca']:
                upload_ca_cert(cert_path, j['partner_domain'])
            else:
                upload_partner_cert(cert_path, j['name'], j['id'], j['partner_domain'], j['partner_type'])

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
            p = json.load(open(policy['policy_file'], 'rt'))
            myprint(r)
            if r['errors'] is not None:  
                if r['errors']['errorCode'] == 'PMS_PRT_005':  # Partner does not exist, add only then
                    myprint('Sending partner-policy mapping request for (PARTNER: %s, POLICY: %s)' % (j['id'], 
                              j['name']))
                    r = session1.add_partner_api_key_requests(j['id'], p['name'], p['description'])
                    myprint(r)
                    api_request_id = r['response']['apiRequestId']
            
                    # Approve
                    myprint('Approving request for (PARTNER: %s, POLICY: %s)' % (j['id'], p['name']))
                    r =  session2.approve_partner_policy(api_request_id, 'Approved')
                    myprint(r)
            else:
                if r['response'][0]['apiKeyRequestStatus'] == 'In-Progress':
                    api_request_id = r['response'][0]['apiKeyReqID']
                    myprint('Approving request for (PARTNER: %s, POLICY: %s)' % (j['id'], p['name']))
                    r =  session2.approve_partner_policy(api_request_id, 'Approved')
                    myprint(r)

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
   parser.add_argument('action', help='policy_group|policy|extractor|partner|upload_certs|partner_policy|misp. For policy specify partner json (not a policy json) ') 
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

    init_logger('full', 'a', './out.log', level=logging.INFO)  # Append mode
    init_logger('last', 'w', './last.log', level=logging.INFO, stdout=False)  # Just record log of last run

    try:
        if args.action == 'policy_group':  # policy_group jsons
            add_policy_group(files)
        if args.action == 'policy':  # policy jsons
            add_policy(files)
        if args.action == 'partner':  # partner jsons
            add_partner(files)
        if args.action == 'extractor':
            add_extractor(files) # partner jsons
        if args.action == 'upload_certs':
            upload_certs(files) # partner jsons
        if args.action == 'partner_policy':
            map_partner_policy(files)
        if args.action == 'misp': # misp jsons
            create_misp(files)
    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    return sys.exit(0)

if __name__=="__main__":
    main()
