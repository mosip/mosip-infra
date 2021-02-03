#!/bin/python3

import sys
import argparse
from api import *
import csv
import json
import config as conf
from db import *
sys.path.insert(0, '../')
from utils import *

def get_machine_id(name):
    '''
    Given a machine name check if already exists in machine_master table
    TODO: We are using direct db query here 'cause mosip api returns results only if machines are active. 
          Revert to API later. 
    '''
    machine_id = None
    db = DB(conf.db_user, conf.db_pwd, conf.db_host, conf.db_port, 'mosip_master') 
    rows = db.get_machines()
    for row in rows: 
        if row[1] == name: 
            machine_id = row[0]
    db.close()
    return machine_id

def machine_exists(name, language):
    '''
    Whether a row with this (name, language) exists in DB.
    TODO: We are using direct db query here 'cause mosip api returns results only if machines are active
          Revert to API later. 
    '''
    db = DB(conf.db_user, conf.db_pwd, conf.db_host, conf.db_port, 'mosip_master') 
    rows = db.get_machines()
    exists = False
    for row in rows: 
        if row[1] == name and row[13] == language : 
            exists = True
            break
    db.close()
    return exists
 
def add_type(files):
    session = MosipSession(conf.server, conf.superadmin_user, conf.superadmin_pwd, ssl_verify=conf.ssl_verify)
    for f in files:
        j  = json.load(open(f, 'rb'), encoding='utf-8')
        for i,l in enumerate(j['languages']):
            myprint('Adding machine type (%s,%s)' % (j['code'], j['languages'][i]))
            r = session.add_type(j['code'], j['name'][i], j['description'][i], j['languages'][i])
            if r['errors'] is None:
                 continue 
            else:
                if r['errors'][0]['errorCode'] == 'KER-MSD-994' or \
                   r['errors'][0]['errorCode'] == 'KER-MSD-061':
                    myprint('Updating machine type (%s,%s)' % (j['code'], j['languages'][i]))
                    r = session.update_machine_type(j['code'], j['name'][i], j['description'][i], j['languages'][i])
                    if r['errors'] is None:
                        continue
                myprint(r)
           

def add_spec(files):
    session = MosipSession(conf.server, conf.superadmin_user, conf.superadmin_pwd, ssl_verify=conf.ssl_verify)
    for f in files:
        j  = json.load(open(f, 'rt'))
        for i,language in enumerate(j['languages']):
            spec_id = get_spec_id(j['name'][i])
            if spec_id is None:
                spec_id = 'any'  # Placehoder. Can't be empty
            
            exists, _ = spec_exists(j['name'][i], language)
            if not exists:
                myprint('Adding machine spec (%s,%s)' % (j['name'][i], language))
                r = session.add_spec(spec_id, j['name'][i], j['type_code'], j['brand'][i], j['model'][i],
                                             j['description'][i], language, j['min_driver_ver'])
            else:
                myprint('Updating machine spec (%s,%s)' % (j['name'][i], language))
                r = session.update_machine_spec(spec_id, j['name'][i], j['type_code'], j['brand'][i], 
                                                j['model'][i], j['description'][i], language, j['min_driver_ver'])
            if r['errors'] is not None:
                myprint('ABORTING')
                break
            
def get_spec_id(spec_name):
    '''
    Only spec name given here. If spec exists for any language, the id shall be returned
    '''
    session = MosipSession(conf.server, conf.superadmin_user, conf.superadmin_pwd, ssl_verify=conf.ssl_verify)
    r = session.get_specs()
    spec_id = None
    if r['errors'] is None:
        for spec in r['response']['data']: 
            if spec['name'] == spec_name:
                spec_id = spec['id']  
                break
    return spec_id

def spec_exists(spec_name, language):
    session = MosipSession(conf.server, conf.superadmin_user, conf.superadmin_pwd, ssl_verify=conf.ssl_verify)
    r = session.get_specs()
    spec_id = None
    exists = False
    if r['errors'] is None:
        for spec in r['response']['data']: 
            if spec['name'] == spec_name and spec['langCode'] == language:
                spec_id = spec['id']  
                exists = True
                break
    return exists, spec_id

def add_machine(files):
    session = MosipSession(conf.server, conf.superadmin_user, conf.superadmin_pwd, ssl_verify=conf.ssl_verify)
    for f in files:
        j  = json.load(open(f, 'rt'))
        pub_key = open(j['pub_key_path'], 'rt').read().strip()
        sign_pub_key = open(j['sign_pub_key_path'], 'rt').read().strip()
        for i,language in enumerate(j['languages']):
            myprint('Getting spec id of  machine %s' % j['spec_name'][i])
            spec_id = get_spec_id(j['spec_name'][i])
            if spec_id is None:
                myprint('ABORTING: spec id for (%s,%s) not found' % (j['name'][i], language))
                break

            machine_id = get_machine_id(j['name'][i]) 
            if machine_id is None:
                machine_id = ''
    
            exists = machine_exists(j['name'][i], language)
            if not exists:
                myprint('ADDING machine (%s,%s)' % (j['name'][i], language))
                r = session.add_machine(machine_id, j['name'][i], spec_id, pub_key, j['reg_center_id'], 
                                        j['serial_num'], sign_pub_key, j['validity'], j['zone_id'], language)
            else:
                myprint('UPDATING machine (%s,%s)' % (j['name'][i], language))
                r = session.update_machine(machine_id, j['name'][i], spec_id, pub_key, j['reg_center_id'], 
                                        j['serial_num'], sign_pub_key, j['validity'], j['zone_id'], language)
            myprint(r)

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('action', help='type|spec|machine')
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

    if args.action == 'type':
        add_type(files)
    if args.action == 'spec':
        add_spec(files)
    if args.action == 'machine':
        add_machine(files)

if __name__=="__main__":
    main()
