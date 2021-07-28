#!/bin/python3

import sys
import argparse
from api import *
import json
sys.path.insert(0, '../')
from utils import *

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('server', type=str, help='Full url to point to the server')
   parser.add_argument('partner_id', help='Partner id')
   parser.add_argument('policy_name', help='Name of approved policy in auth_policy table')
   parser.add_argument('user', type=str, help='User with PARTNER and PARTNERMANAGER role')
   parser.add_argument('user_pwd', type=str, help='Password for user')
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
        session = MosipSession(args.server, args.user, args.user_pwd, 'partner', ssl_verify=ssl_verify)
        # Request for api key
        r =  session.add_partner_api_key_requests(args.partner_id, args.policy_name, '')
        myprint(r)
        api_key = r['response']['apiRequestId']

        # Approve api key (by admin). Assuming user has all the necessary roles
        #r = session.approve_partner_policy(api_key, 'Approved')
        #myprint(r)

    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    return sys.exit(0)

if __name__=="__main__":
    main()
