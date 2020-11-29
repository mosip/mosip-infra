#!/bin/python3

import sys
import argparse
from ida_zk_api import *
import csv
import json
import traceback
import config as conf
sys.path.insert(0, '../')
from utils import *

def fetch_and_upload_cert():
    session = MosipSession(conf.server, conf.client_id, conf.client_pwd)
    myprint('Getting certificate from IDA:CRED_SERVICE')
    r = session.get_ida_internal_cert()
    myprint(r)
    if len(r['errors']) != 0:
        myprint('ABORTING')
        return 1 
    cert = r['response']['certificate']

    # Upload
    myprint('Uploading cert to keymanager')
    r = session.upload_other_domain_cert(cert)
    myprint(r)
    if r['errors'] is not None:
        myprint('ABORTING')
        return 1 
    return 0

def main():

    init_logger('./out.log')
    try:
        r = fetch_and_upload_cert()
    except:
        exc_type, exc_value, exc_traceback = sys.exc_info()
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    sys.exit(r)

if __name__=="__main__":
    main()
