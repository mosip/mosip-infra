#!/bin/python3

import sys
import argparse
import config as conf
import base64
from api import *
from db import *
sys.path.insert(0, '../')
from utils import *

def spec_exists_in_masterdb(name, session):
    '''
    Check if spec the name exists
    '''
    r = session.get_specs_from_masterdb()
    if r['errors'] is None:
        rows = r['response']['data']
        spec_id = None
        for row in rows:
            if row['name'] == name:
                return True, row['id']
    return False, None 

def get_spec_id_from_masterdb(name, session):
    r = session.get_specs_from_masterdb()
    if r['errors'] is None:
        rows = r['response']['data']
        spec_id = None
        for row in rows:
            if row['name'] == name:
                return row['id']
    return None
 
def get_device_id_from_masterdb(name):
    '''
    Given a device name check if already exists in device_master table
    TODO: We are using direct db query here 'cause mosip api returns results only if devices are active. 
          Revert to API later. 
    '''
    device_id = None
    db = DB(conf.db_user, conf.db_pwd, conf.db_host, conf.db_port, 'mosip_master') 
    rows = db.get_devices()
    for row in rows: 
        if row[1] == name: 
            device_id = row[0]
    db.close()
    return device_id

def device_exists_in_masterdb(name, language):
    '''
    Whether a row with this (name, language) exists in DB.
    TODO: We are using direct db query here 'cause mosip api returns results only if machines are active
          Revert to API later. 
    '''
    db = DB(conf.db_user, conf.db_pwd, conf.db_host, conf.db_port, 'mosip_master') 
    rows = db.get_devices()
    exists = False
    for row in rows: 
        if row[1] == name and row[9] == language:
            exists = True
            break
    return exists
    db.close()

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

def add_spec(files):
    '''
    We update spec in both regdevice and masterdb. The 'name' field is only used as a field to find out
    if spec already exists in masterdb. 
    Languages are only required for masterdb.
    '''
    session = MosipSession(conf.server, conf.device_provider_user, conf.device_provider_pwd, 
                           ssl_verify=conf.ssl_verify)
    session2 = MosipSession(conf.server, conf.superadmin_user, conf.superadmin_pwd, ssl_verify=conf.ssl_verify)

    for f in files:
        j  = json.load(open(f, 'rt'))
        myprint('Adding device spec for  %s' % j['id'])
        r = session.add_device_detail(j['id'], j['type'], j['sub_type'], j['for_registration'], j['make'], 
                                      j['model'], j['partner_name'], j['partner_id'])
        if r['errors'] is not None: 
            if r['errors']['errorCode'] ==  'PMS_AUT_003':  # Device exists
                myprint('Device spec exists. Updating device spec for  %s' % j['id'])
                r = session.update_device_detail(j['id'], j['type'], j['sub_type'], j['for_registration'], 
                                              j['make'], j['model'], j['partner_name'], j['partner_id'])
            
                if r['errors'] is not None:
                    myprint(r)

        myprint('Approving device %s' % j['id'])
        r = session.approve_device_detail(j['id'], 'Activate', j['for_registration']) # Activate/De-activate
        if r['errors'] is not None:
            myprint(r)

        exists, spec_id = spec_exists_in_masterdb(j['name'], session2)
        if exists:
            myprint('Updating device detail (spec) in master db')
            for language in j['languages']:
                myprint('Updating device spec in master db for (%s,%s)' % (j['name'], language))
                r = session2.update_spec_in_masterdb(spec_id, j['name'], language)
        else:
            spec_id = 'any'
            for language in j['languages']:
                myprint('Adding device spec in master db for (%s,%s)' % (j['name'], language))
                r = session2.add_spec_in_masterdb(spec_id, j['name'], language)
                _, spec_id = spec_exists_in_masterdb(j['name'], session2)
       
        if r['errors'] is not None: 
            myprint(r)       
                

def add_sbi(files):
    '''
    Add Secure Biometric Inteface (MDS) details.
    files: spec files
    Add sbi and approve.  Here were have added approval in this function itself, 'casue we need to pull the
    corresponding sbi id which is auto generated.
    The API here will create multiple rows in the ables if SBI is added again. This behaviour will be 
    corrected in 1.1.4.
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
    '''
    TODO:  Device info update in mosip_regdevice DB is NOT supported as of now. So you won't be able to change
    info in the same.  However, info will get updated in Masterdb. 
    '''
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
 
        spec_id = get_spec_id_from_masterdb(spec['name'], session2)

        for language in  j['languages']:
            device_id = get_device_id_from_masterdb(j['name'])
            if device_id is None:
                device_id = ''
            exists = device_exists_in_masterdb(j['name'], language)
            if exists:
                myprint('UPDATING device (%s,%s) to master db' % (j['name'], language))
                r = session2.update_device_to_masterdb(device_id, j['name'], j['serial_num'], spec_id, j['reg_center'], 
                                                       j['zone'], j['expiry'], language)
                myprint(r)
            else:
                myprint('ADDING device (%s,%s) to master db' % (j['name'], language))
                r = session2.add_device_to_masterdb(device_id, j['name'], j['serial_num'], spec_id, j['reg_center'], 
                                                    j['zone'], j['expiry'], language)
                myprint(r)

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('action', help='spec|sbi|register')
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
        add_spec(files)  # spec json
    if args.action == 'sbi':
        add_sbi(files)  # spec json
    if args.action == 'register':  # device json
        register_device(files)

if __name__=="__main__":
    main()
