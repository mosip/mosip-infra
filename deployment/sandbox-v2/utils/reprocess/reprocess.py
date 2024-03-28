#!/bin/python3

import sys
import traceback
import argparse
import csv
import time
import config as conf
from api import *
from db import *
from utils import *

def reprocess_packets(registrations, delay):
    '''
    rids:  List of rids
    '''
    session = MosipSession(conf.server, conf.client_id, conf.client_pwd, ssl_verify=conf.ssl_verify, client_token=True)
    for registration in registrations:
        r = session.notify_securezone(registration)
        myprint(r)
        time.sleep(delay)

def read_rids(filename):
    '''
    Read rids from a file with a list of rids one on each line
    '''
    registrations = open(filename, 'rt').readlines()
    registrations = [r.strip() for r in registrations]  # Strip newline char
    registrations = [tuple(map(str, r.split(', '))) for r in registrations if len(r) != 0]  # Filter empty lines
    return registrations

def fetch_rids_from_db(query):
    db = DB(conf.db_user, conf.db_pwd, conf.db_host, conf.db_port, 'mosip_regprc') 
    rids = db.get_rids(query)
    return rids
   
def args_parse(): 
   parser = argparse.ArgumentParser()
   group = parser.add_mutually_exclusive_group(required=True)
   group.add_argument('--registration', type=str,  help='RID to be processed')
   group.add_argument('--file', type=str,  help='File containing newline seperated list of RIDs')
   group.add_argument('--db', action='store_true',  help='Query db and get RIDs')
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

    init_logger('full', 'a', './out.log', level=logging.INFO)  # Append mode
    init_logger('last', 'w', './last.log', level=logging.INFO, stdout=False)  # Just record log of last run
   
    if args.registration:
       registrations = [tuple(map(str, r.split(', '))) for r in [args.registration] if len(r) != 0]
    elif args.file:
      registrations = read_rids(args.file)
    elif args.db:
      registrations = fetch_rids_from_db(conf.query)
    else:    
       parser.print_usage()
       
    try:
       reprocess_packets(registrations, conf.delay)
    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    sys.exit(0)

if __name__=="__main__":
    main()
