#!/bin/python3

import sys
import traceback
import argparse
import csv
from api import *
sys.path.insert(0, '../')
from utils import *

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('server', type=str, help='Full url to point to the server')
   parser.add_argument('user', type=str, help='Keycloak username that needs to be mapped')
   parser.add_argument('regcenter', type=str, help='Registration center id')
   parser.add_argument('admin', type=str, help='Keycloak user with GLOBAL_ADMIN and ZONAL_ADMIN role who is adding user')
   parser.add_argument('admin_pwd', type=str, help='Password for admin')
   parser.add_argument('client_pwd', type=str, help='Password for mosip-regproc-client')
   parser.add_argument('--update', help='Update info in DB. By default info will not be updated', action='store_true')
   parser.add_argument('--disable_ssl_verify', help='Disable ssl cert verification while connecting to server', action='store_true')
   args = parser.parse_args()
   return args

def main():
    args =  args_parse() 

    ssl_verify = True
    if args.disable_ssl_verify:
        ssl_verify = False

    update = False
    if args.update:
        update = True

    init_logger('full', 'a', './out.log', level=logging.INFO)  # Append mode

    try:
        session = MosipSession(args.server, args.admin, args.admin_pwd, 'mosip-regproc-client', args.client_pwd, 
                               'regproc', ssl_verify)
        r = session.map_user_to_reg_center(args.user, args.regcenter)
        myprint(r)
    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    sys.exit(0)

if __name__=="__main__":
    main()
