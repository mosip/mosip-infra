#!/bin/python3

import sys
import traceback
import argparse
import csv
import config as conf
from api import *
from utils import *

def reprocess_packets(rids):
    '''
    rids:  List of rids
    '''
    session = MosipSession(conf.server, conf.client_id, conf.client_pwd, ssl_verify=conf.ssl_verify, client_token=True)
    for rid in rids:
        r = session.notify_securezone(rid)
        myprint(r)

def read_rids(filename):
    '''
    Read rids from a file with a list of rids one on each line
    '''
    rids = open(filename, 'rt').readlines()
    rids = [r.strip() for r in rids]  # Strip newline char
    rids = [r for r in rids if len(r) != 0]  # Filter empty lines
    return rids
   
def args_parse(): 
   parser = argparse.ArgumentParser()
   group = parser.add_mutually_exclusive_group(required=True)
   group.add_argument('--rid', type=str,  help='RID to be processed')
   group.add_argument('--file', type=str,  help='File containing newline seperated list of RIDs')
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
   
    if args.rid:
       rids = [args.rid]
    elif args.file:
      rids = read_rids(args.file)
    else:    
       parser.print_usage()
       
    try:
       reprocess_packets(rids) 
    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    sys.exit(0)

if __name__=="__main__":
    main()
