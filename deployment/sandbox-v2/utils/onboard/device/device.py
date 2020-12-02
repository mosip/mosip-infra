#!/bin/python3

import sys
import argparse
from device_api import *
import csv
import config as conf
sys.path.insert(0, '../')
from utils import *

def add_device_detail(csv_file):
    session = MosipSession(conf.server, conf.device_provider_user, conf.device_provider_pwd)
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        myprint('Adding device detail for  %s' % row['device_id'])
        r = session.add_device_detail(row['device_id'], row['type'], row['subtype'], row['for_registration'], 
                                     row['make'], row['model'], row['partner_org_name'], row['partner_id'])
        myprint(r)

def approve_device_detail(csv_file): # status: Activate/De-activate 
    session = MosipSession(conf.server, conf.device_provider_user, conf.device_provider_pwd)
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        myprint('Approving device %s' % row['device_id'])
        r = session.approve_device_detail(row['device_id'], row['status'], row['for_registration'])
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

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('action', help='add|approve|sbi|all')
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

if __name__=="__main__":
    main()
