#!/bin/python3

import sys
sys.path.insert(0, '../')
from utils import *
from api import *
import config as conf
import csv

class App:
    def __init__(self, conf):
        self.mosip = MosipSession(conf.server, conf.partner_user, conf.partner_password, 'partner')

    #def add_partner(self, name, contact, address, email, partner_id, partner_type, policy_group):
    def add_partner(self, csv_file):
        reader = csv.DictReader(open(csv_file, 'rt')) 
        for row in reader:
            print('Adding partner %s' % row['name'])
            r = self.mosip.add_partner(row['name'], row['contact'], row['address'], row['email'], row['id'], 
                                        row['type'], row['policy_group'])
            r = response_to_json(r)
            if r['errors']:
                print(r)

def main():

    app = App(conf) 

    app.add_partner(conf.csv_partner)

if __name__=="__main__":
    main()
