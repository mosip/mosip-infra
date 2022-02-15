#!/usr/local/bin/python3
# Upload masterdata using Admin's bulkupload API.
# TODO: WORK IN PROGRESS.  DO NOT USE.  
import sys
import argparse
from api import *
import csv
import json
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

def bulk_upload_csvs_using_api(files, table_order):
    session = MosipSession(conf.server, conf.superadmin_user, conf.superadmin_pwd, ssl_verify=conf.ssl_verify)
    for f in table_order:
        for fi in files:
            if f==os.path.basename(fi).split('.')[0]:
                myprint(fi)
                r=session.bulk_upload('masterdata',fi,'insert',f)
                r=response_to_json(r)
                myprint(r)
                if len(r['errors'])!=0:
                    sys.exit(10)
                if r['response']['status']!='COMPLETED':
                    if r['response']['statusDescription'].find('Duplicate Record') == -1:
                        sys.exit(11)

def args_parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('path', help='directory containing all the tables in csv format')
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

    bulk_upload_csvs_using_api(files,table_order)

if __name__=="__main__":
    main()
