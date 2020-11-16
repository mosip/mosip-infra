#!/bin/python3

import sys
sys.path.insert(0, '../')
from utils import *
from api import *
import config as conf
import csv

class App:
    def __init__(self, conf):
        self.mosip = MosipSession(conf.server, conf.device_provider_user, conf.device_provider_pwd, 'partner')

    def add_device_detail(self, csv_file):
        reader = csv.DictReader(open(csv_file, 'rt')) 
        for row in reader:
            print('Adding device %s:%s' % (row['device_type'], row['device_id']))
            r = self.mosip.add_device_detail(row['device_id'], row['device_type'], row['device_subtype'], 
                                             row['for_registration'], row['make'], row['model'], 
                                             row['partner_org_name'], row['partner_id'])
            r = response_to_json(r)
            print(r)

    def approve_device_detail(self, csv_file):
        '''
        status: Activate/De-activate 
        '''
        reader = csv.DictReader(open(csv_file, 'rt')) 
        for row in reader:
            print('Updating status of device %s' % (row['device_id']))
            r = self.mosip.approve_device(row['device_id'], row['status'], row['for_registration'])
            r = response_to_json(r)
            print(r)

def main():

    app = App(conf) 

    app.add_device_detail(conf.csv_device)
    app.approve_device_detail(conf.csv_device_approval)
    app.add_sbi(conf.csv_sbi)

if __name__=="__main__":
    main()
