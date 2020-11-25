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

    def add_sbi(self, csv_file):
        reader = csv.DictReader(open(csv_file, 'rt')) 
        for row in reader:
            print('Add SBI version %s for device detail %s' % (row['sw_version'], row['device_detail_id']))
            r = self.mosip.add_sbi(row['device_detail_id'], row['sw_hash'], row['sw_create_date'], 
                                   row['sw_expiry_date'], row['sw_version'], row['for_registration'])
            r = response_to_json(r)
            print(r)

def main():

    app = App(conf) 

    app.add_sbi(conf.csv_sbi)

if __name__=="__main__":
    main()
