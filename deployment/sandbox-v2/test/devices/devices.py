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
        print('Updating device type')
        reader = csv.DictReader(open(CSV_DEVICE_TYPE, 'rt')) 
        for row in reader:
            r =  self.mosip.update_masterdata_devicetype(row['code'], row['name'], row['description'])
            if r['errors']:
                print(r)
    
    def update_device_spec(self, csv_file):
        print('Updating device specification')
        reader = csv.DictReader(open(CSV_DEVICE_SPEC, 'rt')) 
        for row in reader:
            r = self.mosip.update_masterdata_device_spec(row['brand'], row['description'], row['type_code'], 
                                                         row['name'], row['spec_id'], row['driver_version'], 
                                                         row['model']) 
            if r['errors']:
                print(r)
       
def main():

    app = App(conf) 

    app.update_device_type(CSV_DEVICE_TYPE)
    app.update_device_spec(CSV_DEVICE_SPEC)


if __name__=="__main__":
    main()
