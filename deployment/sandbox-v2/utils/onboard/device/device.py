#!/bin/python3

import sys
import argparse
from device_api import *
import csv
import config as conf
import base64
sys.path.insert(0, '../')

from utils import *

def get_digital_id(index):
    '''
    index: str
    Returns base64 encoded digital id matching index.
    '''
    reader = csv.DictReader(open(conf.csv_digital_id, 'rt')) 
    for row in reader:
        if row['index'] == index: 
            digital_id =  {
                'serialNo': row['serial_num'],
                'deviceProvider': row['device_provider'],
                'deviceProviderId': row['device_provider_id'],
                'make': row['make'],
                'model': row['model'],
                'dateTime': row['datetime'],
                'type': row['type'], 
                'deviceSubType': row['sub_type']
            }
            j = json.dumps(digital_id)
            b64_j = base64.b64encode(j.encode()) # bytes
            b64_j = b64_j.decode() # str 
            return digital_id, b64_j
    return None,None

def create_device_info(digital_id, row):  # row in csv file
    ts = get_timestamp()
    device_info = { 
        'deviceSubId': row['sub_id'], 
        'certification': row['certification'],
        'digitalId': digital_id,
        'firmware': row['firmware'], 
        'deviceExpiry': row['expiry'],
        'timeStamp': ts
    }
    return device_info

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

def add_device_detail(csv_file):
    session = MosipSession(conf.server, conf.device_provider_user, conf.device_provider_pwd)
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        myprint('Adding device detail for  %s' % row['device_detail_id'])
        r = session.add_device_detail(row['device_detail_id'], row['type'], row['subtype'], row['for_registration'], 
                                     row['make'], row['model'], row['partner_org_name'], row['partner_id'])
        myprint(r)

def approve_device_detail(csv_file): # status: Activate/De-activate 
    session = MosipSession(conf.server, conf.device_provider_user, conf.device_provider_pwd)
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        myprint('Approving device %s' % row['device_detail_id'])
        r = session.approve_device_detail(row['device_detail_id'], row['status'], row['for_registration'])
        myprint(r)

def add_sbi(csv_file):
    '''
    Add sbi and approve.  Here were have added approval in this function itself, 'casue we need to pull the
    corresponding sbi id which is auto generated.
    '''
    session1 = MosipSession(conf.server, conf.device_provider_user, conf.device_provider_pwd)
    session2 = MosipSession(conf.server, conf.partner_manager_user, conf.partner_manager_pwd)
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        myprint('Adding SBI for  %s' % row['device_detail_id'])
        r = session1.add_sbi(row['device_detail_id'], row['sw_hash'], row['sw_create_date'], row['sw_expiry_date'],
                            row['sw_version'], row['for_registration'])
        myprint(r)
        if r['errors'] is None:
            sbi_id = r['response']['id']          
            myprint('Approving SBI %s' % sbi_id)
            r = session2.approve_sbi(sbi_id, 'Activate', 'true') 
            myprint(r)

def register_device(csv_file):
    session1 = MosipSession(conf.server, conf.device_provider_user, conf.device_provider_pwd)
    session2 = MosipSession(conf.server, conf.superadmin_user, conf.superadmin_pwd)
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
       myprint('Registerig device %s' % row['device_id'])
       digital_id, digital_id_b64 = get_digital_id(row['digital_id_index'])     
       if digital_id is None:
           myprint('ERROR: Digitial id for index = %s not found' % row['digital_id_index'])
           continue
       device_info =  create_device_info(digital_id_b64, row)
       device_data =  create_device_data(row['device_id'], row['purpose'], device_info, row['ft_provider_id'])
       r = session1.register_device(device_data)
       myprint(r)
      
       myprint('Add device to master db')

       r = session2.add_device_to_masterdb(row['device_id'], digital_id['serialNo'], row['device_detail_id'], 
                                           row['reg_center'], row['zone'], row['expiry'], conf.primary_lang)
       myprint(r)
        

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('action', help='add|approve|sbi|register|all')
   args = parser.parse_args()
   return args

def main():

    init_logger('./out.log')
    args = args_parse()

    if args.action == 'add' or args.action == 'all':
        add_device_detail(conf.csv_device_detail)
    if args.action == 'approve' or args.action == 'all':
        approve_device_detail(conf.csv_device_approve)
    if args.action == 'sbi' or args.action == 'all':
        add_sbi(conf.csv_sbi)
    if args.action == 'register' or args.action == 'all':
        register_device(conf.csv_device)

if __name__=="__main__":
    main()
