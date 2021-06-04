#!/bin/python3

import sys
from api import *
import traceback
import argparse
import config as conf
sys.path.insert(0, '../')
from utils import *

def fetch_and_upload_cert(from_app_id, from_ref_id, to_app_id, to_ref_id):
    session = MosipSession(conf.server, conf.client_id, conf.client_pwd, ssl_verify=conf.ssl_verify)
    myprint('Getting certificate from %s:%s' % (from_app_id, from_ref_id))
    r = session.get_ida_internal_cert(from_app_id, from_ref_id)
    myprint(r)
    if len(r['errors']) != 0:
        myprint('ABORTING')
        return 1 
    cert = r['response']['certificate']

    # Upload
    myprint('Uploading cert to keymanager %s:%s' % (to_app_id, to_ref_id))
    r = session.upload_other_domain_cert(cert, to_app_id, to_ref_id)
    myprint(r)
    if r['errors'] is not None:
        myprint('ABORTING')
        return 1 
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
        r = fetch_and_upload_cert('IDA', 'CRED_SERVICE', 'IDA', 'PUBLIC_KEY')
    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    sys.exit(r)

if __name__=="__main__":
    main()
