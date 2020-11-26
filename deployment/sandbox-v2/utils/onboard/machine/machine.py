#!/bin/python3

import sys
import argparse
from machine_api import *
import csv
import json
import config as conf
sys.path.insert(0, '../')
from utils import *

def add_machine_type(csv_file):
    session = MosipSession(conf.server, conf.superadmin_user, conf.superadmin_pwd)
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        myprint('Adding machine type %s' % row['name'])
        r = session.add_machine_type(row['code'], row['name'], row['description'], row['language'])
        r = response_to_json(r)
        myprint(r)
        if r['errors'] is not None:
            if r['errors'][0]['errorCode'] == 'KER-MSD-994' or \
               r['errors'][0]['errorCode'] == 'KER-MSD-061':
                myprint('Updating machine type for "%s"' % row['name'])
                r = session.update_machine_type(row['code'], row['name'], row['description'], row['language'])
                r = response_to_json(r)
                myprint(r)
 
def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('action', help='type|all')
   args = parser.parse_args()
   return args

def main():

    args = args_parse()

    if args.action == 'type' or args.action == 'all':
        add_machine_type(conf.csv_machine_type)

if __name__=="__main__":
    main()
