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
   parser.add_argument('name', type=str, help='Machine type name')
   parser.add_argument('machine_type', type=str, help='Machine type code from machine_type table')
   parser.add_argument('brand', type=str, help='Brand of machine')
   parser.add_argument('model', type=str, help='Model of machine')
   parser.add_argument('description', type=str, help='Machine spec description in "quotes"')
   parser.add_argument('language', type=str, help='Language code. You need to add for all languages. The type will not be active till all languages are added.')
   parser.add_argument('min_driver_ver', type=str, help='Minimum driver version')
   parser.add_argument('admin', type=str, help='Keycloak user with GLOBAL_ADMIN role who is adding user')
   parser.add_argument('admin_pwd', type=str, help='Password for admin')
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
        session = MosipSession(args.server, args.admin, args.admin_pwd, 'regproc', ssl_verify)
        r = session.add_machine_spec(args.name, args.machine_type,  args.brand, args.model, 
                                     args.description, args.language, args.min_driver_ver, update=update)
        myprint(r)
    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    sys.exit(0)

if __name__=="__main__":
    main()
