#!/bin/python3

import sys
import argparse
import json
import csv
from api import *
sys.path.insert(0, '../')
from utils import *

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('server', type=str, help='Full url to point to the server')
   parser.add_argument('title', help='Tile for idschema')
   parser.add_argument('description', help='Tile for idschema')
   parser.add_argument('json', help='File containing input data UI schema json')
   parser.add_argument('user', type=str, help='User with GLOBAL_ADMIN role')
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
        session = MosipSession(args.server, args.user, args.user_pwd, 'admin', ssl_verify=ssl_verify)
        j = json.load(open(args.json, 'rt'))
        r = session.upload_idschema(j, args.title, args.description)
        myprint(r)
        if r['errors'] is None:
            schema_id = r['response']['id']
            r = session.publish_idschema(schema_id)
            myprint(r)
    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    return sys.exit(0)

if __name__=="__main__":
    main()
