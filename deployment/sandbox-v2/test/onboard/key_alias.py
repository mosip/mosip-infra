#!/bin/python3

import sys
import argparse
from api import *
import csv
import json
import config as conf
sys.path.insert(0, '../')
from utils import *

def main():

    session = MosipSession(conf.server, conf.keymaker_user, conf.keymaker_pwd, 'partner')
    session.add_pms_key_alias()

if __name__=="__main__":
    main()
