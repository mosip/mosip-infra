#!/bin/python3

import sys
sys.path.insert(0, '../')
from utils import *
from api import *
import config as conf
import csv

class App:
    def __init__(self, conf):
        self.mosip = MosipSession(conf.server, conf.partner_manager_user, conf.partner_manager_pwd, 'partner')

    def approve_sbi(self, csv_file):
        reader = csv.DictReader(open(csv_file, 'rt')) 
        for row in reader:
            print('Updating approval status of SBI %s' % row['sbi_id'])
            r = self.mosip.approve_sbi(row['sbi_id'], row['status'], row['for_registration'])
            r = response_to_json(r)
            print(r)

def main():

    app = App(conf) 

    app.approve_sbi(conf.csv_sbi_approval)

if __name__=="__main__":
    main()
