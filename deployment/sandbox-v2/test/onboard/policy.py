#!/bin/python3

import sys
sys.path.insert(0, '../')
from utils import *
from api import *
import config as conf
import csv

class App:
    def __init__(self, conf):
        self.mosip = MosipSession(conf.server, conf.pm_user, conf.pm_password, 'partner')

    def create_policy_group(self, csv_file):
        reader = csv.DictReader(open(csv_file, 'rt')) 
        for row in reader:
            print('Creating policy group %s' % row['name'])
            r = self.mosip.create_policy_group(row['name'], row['description'])
            if r.status_code == 200: 
                continue
            r = response_to_json(r)
            if r['errors'][0]['errorCode'] == 'PMS_POL_014':  # Policy already exists. Ignore. 
               pass
            else:
                print(r) 

def main():

    app = App(conf) 

    app.create_policy_group(conf.csv_policy_group)

if __name__=="__main__":
    main()
