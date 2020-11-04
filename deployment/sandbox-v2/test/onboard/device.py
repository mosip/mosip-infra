#!/bin/python3

import sys
sys.path.insert(0, '../')
from utils import *
from api import *
import config as conf
import csv

class App:
    def __init__(self, conf):
        self.mosip = MosipSession(conf.server, conf.device_provider_user, conf.device_provider_password, 'partner')

    def add_device(self, csv_file):
        reader = csv.DictReader(open(csv_file, 'rt')) 
        for row in reader:
            print('Adding device %s:%s' % (row['device_type'], row['device_id']))
            r = self.mosip.add_device_detail(row['device_id'], row['device_type'], row['device_subtype'], 
                                             row['for_registration'], row['make'], row['model'], 
                                             row['partner_org_name'], row['partner_id'])
            r = response_to_json(r)
            if r['errors']:
                print(r)

def main():

    app = App(conf) 

    app.add_device(conf.csv_device)

if __name__=="__main__":
    main()
