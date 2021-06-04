# Usage:
# python3 idschema.py

import sys
import traceback
import json
import argparse
import config as conf
import csv
from api import *
sys.path.insert(0, '../')
from utils import *

def upload_and_publish_idschema(csv_file):
    session = MosipSession(conf.server, conf.superadmin_user, conf.superadmin_pwd, ssl_verify=conf.ssl_verify)
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        fp = open(row['ui_spec_file'], 'rt')
        j = json.load(fp)
        r = session.upload_idschema(j, row['title'], row['description'])
        myprint(r)
        if r['errors'] is None:
            schema_id = r['response']['id']
            r = session.publish_idschema(schema_id)
            myprint(r)
    return 0

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('--server', type=str, help='Full url to point to the server.  Setting this overrides server specified in config.py')
   parser.add_argument('--disable_ssl_verify', help='Disable ssl cert verification while connecting to server', action='store_true')
   args = parser.parse_args()
   return args

def main():

    init_logger('full', 'a', './out.log', level=logging.INFO)  # Append mode
    init_logger('last', 'w', './last.log', level=logging.INFO, stdout=False)  # Just record log of last run

    args =  args_parse() 
    if args.server:
        conf.server = args.server   # Overide

    if args.disable_ssl_verify:
        conf.ssl_verify = False

    try:
        r = upload_and_publish_idschema(conf.csv_idschema)
    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    sys.exit(r)

if __name__=="__main__":
    main()
