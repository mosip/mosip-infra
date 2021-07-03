#!/bin/python3

import sys
import traceback
import argparse
import csv
import pandas as pd
from api import *
sys.path.insert(0, '../')
from utils import *

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('server', type=str, help='Full url to point to the server')
   parser.add_argument('xlsx', type=str, help='Excel container machine data')
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

    df = pd.read_excel(args.xlsx)
    try:
        session = MosipSession(args.server, args.admin, args.admin_pwd, 'regproc', ssl_verify)
        for i,row in df.iterrows():
            r = session.add_machine('', df['name'][i], df['spec_name'][i], str(df['regcenter'][i]), 
                                    df['zone'][i], df['pub_key'][i], df['sign_pub_key'][i], 
                                    int(df['valid_days'][i]), df['language'][i], update=update)
            myprint(r)
    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    sys.exit(0)

if __name__=="__main__":
    main()
