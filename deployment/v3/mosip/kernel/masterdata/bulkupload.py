#!/usr/local/bin/python3

import sys
import argparse
from api import *
import csv
import json
import pandas as pd
import config as conf
from utils import *

def get_order_from_list(files_file_name):
    table_order = []
    try:
        with open(files_file_name, 'r') as file:
            for line in file:
                l=line.strip()
                if not l.startswith('#'):
                    table_order.append(l)
    except:
        sys.exit('Table Order file not found ' + files_file_name + ' %tb')
    return table_order
    # return [l.strip() for l in open(files_file_name, 'r') if not l.strip().startswith('#')]

def bulk_upload_csv_files_to_masterdata(files, table_order):
    try:
        os.mkdir('tmp')
    except:
        pass

    session = MosipSession(conf.server, conf.superadmin_user, conf.superadmin_pwd, ssl_verify=conf.ssl_verify)
    for f in table_order:
        for fi in files:
            if f==os.path.basename(fi).split('.')[0]:
                # myprint(os.path.splitext(os.path.basename(f)))
                pd.read_excel(fi).to_csv('tmp/tmp.csv',index=False)
                r=session.bulk_upload('masterdata','tmp/tmp.csv','insert',f)
                myprint(fi)
                myprint(response_to_json(r))
                os.remove('tmp/tmp.csv')
                break
    return 0

def args_parse():
   parser = argparse.ArgumentParser()
   #parser.add_argument('action', help='type|spec|machine')
   parser.add_argument('path', help='directory containing all the tables in xlsx format')
   parser.add_argument('order', help='file that contains the table upload order')
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
    table_order = get_order_from_list(args.order)

    init_logger('full', 'a', './out.log', level=logging.INFO)  # Append mode
    init_logger('last', 'w', './last.log', level=logging.INFO, stdout=False)  # Just record log of last run

    # if args.action == 'type':
    #     add_type(files)
    # if args.action == 'spec':
    #     add_spec(files)
    # if args.action == 'machine':
    #     add_machine(files)
    bulk_upload_csv_files_to_masterdata(files,table_order)

if __name__=="__main__":
    main()
