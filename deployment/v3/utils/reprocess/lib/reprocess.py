#!/bin/python3

import sys
import argparse
from api import *
import json
sys.path.insert(0, '../onboard')
from utils import *

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('server', type=str, help='Full url to point to the server')
   parser.add_argument('rid', type=str, help='RID to be reprocessed')
   parser.add_argument('workflow_id', type=str, help='Workflow id from registration table against this RID')
   parser.add_argument('client_pwd', type=str, help='Password for mosip-regproc-client')
   parser.add_argument('--disable_ssl_verify', help='Disable ssl cert verification while connecting to server', action='store_true')
   args = parser.parse_args()
   return args, parser

def main():
    args, parser =  args_parse() 

    ssl_verify = True
    if args.disable_ssl_verify:
        ssl_verify = False

    init_logger('full', 'a', './out.log', level=logging.INFO)  # Append mode

    try:
        session = MosipSession(args.server, '', '', 'mosip-regproc-client', args.client_pwd, 'regproc', ssl_verify, 
                               client_token=True)
        r = session.notify_securezone(args.rid, args.workflow_id)
        myprint(r)

    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    return sys.exit(0)

if __name__=="__main__":
    main()
