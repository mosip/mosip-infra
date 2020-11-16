#!/bin/python3

import sys
from api import *
import config as conf
import csv
sys.path.insert(0, '../')
from utils import *

class App:
    def __init__(self, conf):
        self.mosip = MosipSession(conf.server, conf.superadmin_user, conf.superadmin_pwd, 'admin')

    def add_device_spec_in_masterdb(self, csv_file):
        reader = csv.DictReader(open(csv_file, 'rt')) 
        for row in reader:
            print('Adding device spec %s in master db' % (row['name']))
            if row['language'] == conf.primary_lang:
                r = self.mosip.add_device_spec_in_masterdb('dummy', row['name'], row['description'], 
                                                           row['device_type'], row['make'], row['model'], 
                                                           row['min_driver_ver'], row['language'])
                r = response_to_json(r)
                print(r)
                spec_id = r['response']['id']

            elif row['language'] == conf.secondary_lang: # assumption that previous row was primary
                r = self.mosip.add_device_spec_in_masterdb(spec_id, row['name'], row['description'], 
                                                           row['device_type'], row['make'], row['model'], 
                                                           row['min_driver_ver'], row['language'])
                r = response_to_json(r)
                print(r)

    #def add_device_type_in_masterdb(self, code, name, description, language):
    def add_device_type_in_masterdb(self, csv_file):
        reader = csv.DictReader(open(csv_file, 'rt')) 
        for row in reader:
            print('Adding device type %s in master db' % (row['code']))
            r = self.mosip.add_device_type_in_masterdb(row['code'], row['name'], row['description'], row['language'])
            r = response_to_json(r)
            print(r)


def main():

    app = App(conf) 

    #app.add_device_type_in_masterdb(conf.csv_device_type)
    app.add_device_spec_in_masterdb(conf.csv_device_spec)

if __name__=="__main__":
    main()
