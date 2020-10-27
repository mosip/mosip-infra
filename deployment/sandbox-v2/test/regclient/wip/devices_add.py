#!/bin/python3

import sys
sys.path.insert(0, '../')
from utils import *
from api import *
import config as conf
import csv

CSV_DEVICES = 'data/devices.csv'

class App:
    def __init__(self, conf):
        self.mosip = MosipSession(conf.server, conf.user, conf.password)

    def add_devices(self, csv_file):
        print('Adding devices type')
        reader = csv.DictReader(open(csv_file, 'rt')) 
        for row in reader:
            r = self.mosip.add_masterdata_device(row['device_id'], row['name'], row['spec'], row['reg_center'], 
                                                 row['valid_upto'], row['zone'])
            if r['errors']:
                print(r)
    
def main():

    app = App(conf) 

    app.add_devices(CSV_DEVICES)


if __name__=="__main__":
    main()
