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
   parser.add_argument('xlsx', type=str, help='Excel container machine specification data')
   parser.add_argument('admin', type=str, help='Keycloak user with GLOBAL_ADMIN role who is adding user')
   parser.add_argument('admin_pwd', type=str, help='Password for admin')
   parser.add_argument('--disable_ssl_verify', help='Disable ssl cert verification while connecting to server', action='store_true')
   args = parser.parse_args()
   return args

def main():
    args =  args_parse() 

    ssl_verify = True
    if args.disable_ssl_verify:
        ssl_verify = False

    init_logger('full', 'a', './out.log', level=logging.INFO)  # Append mode

    df = pd.read_excel(args.xlsx)

    try:
        session = MosipSession(args.server, args.admin, args.admin_pwd, 'regproc', ssl_verify)
        for i,row in df.iterrows():
            r = session.add_type(df['code'][i], df['name'][i], df['description'][i], df['language'][i], 
                                 update=True)
            myprint(r)
    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    sys.exit(0)

if __name__=="__main__":
    main()
