#!/bin/python3

import sys
import argparse
import config as conf
import base64
from api import *
from db import *
sys.path.insert(0, '../')
from utils import *

def get_digital_id(device, spec):
    '''
    device: dict with device info
    spec: dict with spec info
    Returns base64 encoded digital id matching index.
    '''
    digital_id =  {
        'serialNo': device['serial_num'],
        'deviceProvider': spec['partner_name'],
        'deviceProviderId': spec['partner_id'],
        'make': spec['make'],
        'model': spec['model'],
        'type': spec['type'], 
        'deviceSubType': spec['sub_type'],
        'dateTime': device['datetime'],
    }
    j = json.dumps(digital_id)
    b64_j = base64.b64encode(j.encode()) # bytes
    b64_j = b64_j.decode() # str 
    return digital_id, b64_j
    return None,None

def create_device_info(digital_id, device):  
    '''
    device: dict with device info
    '''
    ts = get_timestamp()
    device_info = { 
        'deviceSubId': device['sub_id'], 
        'certification': device['certification'],
        'digitalId': digital_id,
        'firmware': device['firmware'], 
        'deviceExpiry': device['expiry'],
        'timeStamp': ts
    }
    j = json.dumps(device_info)
    b64_j = base64.b64encode(j.encode()) # bytes
    b64_j = b64_j.decode() # str 
    return b64_j

def create_device_data(device_id, purpose, device_info, ft_provider_id):
    device_data = {
        'deviceId' : device_id,
        'purpose' : purpose, 
        'deviceInfo' : device_info,
        'foundationalTrustProviderId': ft_provider_id
    }
    j = json.dumps(device_data)
    b64_j = base64.b64encode(j.encode()) # bytes
    b64_j = b64_j.decode() # str 
    return b64_j

def add_device_spec(files):
    session = MosipSession(conf.server, conf.device_provider_user, conf.device_provider_pwd, ssl_verify=conf.ssl_verify)
    db = DB(conf.db_user, conf.db_pwd, conf.db_host, conf.db_port, 'mosip_master') 
    for f in files:
        j  = json.load(open(f, 'rt'))
        myprint('Adding device spec for  %s' % j['id'])
        r = session.add_device_detail(j['id'], j['type'], j['sub_type'], j['for_registration'], j['make'], 
                                      j['model'], j['partner_name'], j['partner_id'])
        myprint(r)

        myprint('Approving device %s' % j['id'])
        r = session.approve_device_detail(j['id'], 'Activate', j['for_registration']) # Activate/De-activate
        myprint(r)

        myprint('Adding device detail (spec) in master db')
        db.insert_spec_in_masterdb_sql(j['id'])
                
    db.close()

def add_sbi(files):
    '''
    Add Secure Biometric Inteface (MDS) details.
    files: spec files
    Add sbi and approve.  Here were have added approval in this function itself, 'casue we need to pull the
    corresponding sbi id which is auto generated.
    '''
    session1 = MosipSession(conf.server, conf.device_provider_user, conf.device_provider_pwd, 
                            ssl_verify=conf.ssl_verify)
    session2 = MosipSession(conf.server, conf.partner_manager_user, conf.partner_manager_pwd, 
                            ssl_verify=conf.ssl_verify)
    for f in files:
        spec  = json.load(open(f, 'rt'))
        myprint('Adding SBI for  %s' % spec['id'])
        sbi = spec['sbi'] 
        r = session1.add_sbi(spec['id'], sbi['hash'], sbi['create_date'], sbi['expiry'],
                             sbi['version'], spec['for_registration'])
        myprint(r)
        if r['errors'] is None:
            sbi_id = r['response']['id']          
            myprint('Approving SBI %s' % sbi_id)
            r = session2.approve_sbi(sbi_id, 'Activate', 'true') 
            myprint(r)

def register_device(files):
    session1 = MosipSession(conf.server, conf.device_provider_user, conf.device_provider_pwd, 
                            ssl_verify=conf.ssl_verify)
    session2 = MosipSession(conf.server, conf.superadmin_user, conf.superadmin_pwd, ssl_verify=conf.ssl_verify)
    for f in files:
        j  = json.load(open(f, 'rt'))
        spec = json.load(open(j['spec_file'], 'rt'))
        myprint('Registerig device %s' % j['id'])
        digital_id, digital_id_b64 = get_digital_id(j, spec)
        device_info =  create_device_info(digital_id_b64, j)
        purpose = ''
        if spec['for_registration']:
            purpose = 'REGISTRATION'
        device_data =  create_device_data(j['id'], purpose, device_info, j['ft_provider_id'])
        r = session1.register_device(device_data)
        myprint(r)
       
        myprint('Add device to master db')
 
        r = session2.add_device_to_masterdb(j['id'], j['serial_num'], spec['id'], j['reg_center'], j['zone'], 
                                            j['expiry'], conf.primary_lang)
   
        myprint(r)
        

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('action', help='spec|sbi|register|all')
   parser.add_argument('path', help='directory or file containing input data json.  For "sbi" provide spec file as input')
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

    if args.action == 'spec':
        add_device_spec(files)  # spec json
    if args.action == 'sbi':
        add_sbi(files)  # spec json
    if args.action == 'register':  # device json
        register_device(files)

if __name__=="__main__":
    main()
