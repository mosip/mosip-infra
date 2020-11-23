#!/usr/bin/python3
# This utility lists all the vars under "defaults" of all Ansible roles
# Run this script from this directory
# $ ./view_vars.py

import os
import glob
import yaml
import pprint

BASE_DIR = '../'
pp = pprint.PrettyPrinter(indent=4)
for root, dirs, files in os.walk(BASE_DIR):
    for d in dirs:
        if d =='defaults':
            var_files = glob.glob(os.path.join(root, '%s/*.yml' % d))
            for f in var_files:
              fd = open(f, 'rt')  
              file_vars = yaml.load(fd)
              print('=============================================')
              print('ROLE: %s' % root)
              pp.pprint(file_vars) 

