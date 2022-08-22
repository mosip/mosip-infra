#!/usr/bin/python
# This script migrates properties in mosip-config from 1.1.5.1 to 1.2.0.1.  
# The scripts excepts an 'ugrade.csv' file that specifies rules for the migration 
# Usage: python prop_migrator <1.1.5.4 prop file> <1.2.0.1 prop file> <upgrade.csv> <out folder>

import argparse
import sys
import os
import re
import argparse
import logging
import pprint
import csv
from collections import defaultdict

def init_logger(filename):
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    fileHandler = logging.FileHandler(filename)
    streamHandler = logging.StreamHandler(sys.stdout)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    streamHandler.setFormatter(formatter)
    fileHandler.setFormatter(formatter)
    logger.addHandler(streamHandler)
    logger.addHandler(fileHandler)
    return logger

def args_parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('prop_1154', help='Property file for 1.1.5.4 version', action='store')
    parser.add_argument('prop_1201', help='Property file for 1.2.0.1 version', action='store')
    parser.add_argument('migration_rules', help='CSV with rules to migrate', action='store')
    parser.add_argument('out_folder', help='Folder where all migrated .properties files are written', action='store')
    args = parser.parse_args()
    return args, parser

def read_props(fname):
    props = {}  # Properties
    lines = open(fname, 'rt')
    for line in lines: 
        line = line.strip()
        if not line.startswith('#') and (line.find('=') != -1): 
            words = line.split('=')
            key = words[0].strip()
            value = words[1].strip()
            if len(value) == 0:
              value = '[EMPTY]'
            props[key] = value

    return props

def read_migration_rules(migration_fname, properties_fname):
    rules = defaultdict(dict) # property: rules
    with open(migration_fname, 'rt') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            if row['property_file'] == properties_fname:
                rules[row['property']] = row  
    return rules

'''
In this function we apply classification '1' only.
'''
def apply_rules(new_properties_file, old_properties_file, rules, out_folder):
    old_props = read_props(old_properties_file)
    new_props = read_props(new_properties_file)
    out_lines = []
    props = rules.keys() 
    os.makedirs(out_folder, exist_ok=True)
    out_path = open(os.path.join(out_folder, os.path.basename(new_properties_file)), 'wt')
    lines = open(new_properties_file, 'rt').readlines()
    for line in lines:
        if len(line.strip()) == 0 or line.strip()[0] == '#': # Filter
            out_path.write(f'{line}')
            continue
        words = line.split('=')
        prop = words[0].strip()
        if prop in props:
            if rules[prop]['classification'] == '1':  
                if prop in old_props.keys():
                    line = f'{prop}={old_props[prop]}\n' # Replace original line
                    logger.info(f'UPDATED: {prop}')
                    if old_props[prop].strip() != new_props[prop].strip():
                        logger.info(f'DIFFERENT: {prop}')
                else:
                    logger.error(f'{prop} not found in {old_properties_file}') 

        out_path.write(f'{line}')
    out_path.close()

logger = init_logger('prop.log')

def main():
    args, parser = args_parse()

    property_fname = os.path.basename(args.prop_1201)
    rules = read_migration_rules(args.migration_rules, property_fname)

    out_path = os.path.join(args.out_folder, property_fname)
    apply_rules(args.prop_1201, args.prop_1154, rules, args.out_folder)

if __name__== '__main__':
    main()
       
