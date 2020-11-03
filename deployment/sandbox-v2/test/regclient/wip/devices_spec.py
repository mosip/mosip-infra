#!/bin/python3

import sys
sys.path.insert(0, '../')
from utils import *
from api import *
import config as conf
import csv

CSV_DEVICE_TYPE = 'data/device_type.csv'
CSV_DEVICE_SPEC = 'data/device_spec.csv'

class App:
    def __init__(self, conf):
        self.mosip = MosipSession(conf.server, conf.user, conf.password)

    def update_device_type(self, csv_file):
        reader = csv.DictReader(open(csv_file, 'rt')) 
        for row in reader:
            print('Updating device type %s, lang=%s' % (row['name'], row['lang']))
            r =  self.mosip.update_masterdata_devicetype(row['code'], row['name'], row['description'], row['lang'])
            if r['errors']:
                print(r)
    
    def update_device_spec(self, csv_file):
        reader = csv.DictReader(open(csv_file, 'rt')) 
        for row in reader:
            print('Updating device spec %s, lang=%s' % (row['name'], row['lang']))
            r = self.mosip.update_masterdata_device_spec(row['brand'], row['description'], row['type_code'], 
                                                         row['name'], row['spec_id'], row['driver_version'], 
                                                         row['model'], row['lang']) 
            print(r)
            if r['errors']:
                print(r)
       
def main():

    app = App(conf) 

    app.update_device_type(CSV_DEVICE_TYPE)
    app.update_device_spec(CSV_DEVICE_SPEC)


if __name__=="__main__":
    main()
