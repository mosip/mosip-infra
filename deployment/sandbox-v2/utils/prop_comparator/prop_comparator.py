#!/usr/bin/python
# This script compares two properties files. Reports missing, common, and
# different properties

import argparse
import pprint

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('file1', help='First property file')
    parser.add_argument('file2', help='Second property file')

    return parser

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

def diff_report(fname1, fname2):
    pp = pprint.PrettyPrinter(indent=0)
    props1 = read_props(fname1)    
    props2 = read_props(fname2)    
    set1 = set(props1.keys())      
    set2 = set(props2.keys())      
    
    # Find out common properties with different value
    common = set1.intersection(set2)
    print('DIFFERENT VALUES:\n')
    for k in common:
        v1 = props1[k].strip()
        v2 = props2[k].strip()
        if v1 != v2:
            print(k + ':')    
            print('< ' + v1)
            print('> ' + v2)
            print('')
    print('=======================================================')
    print('\nNEW PROPERTIES in %s' % fname1)  
    pp.pprint(set1 - set2)
    print('')
    print('=======================================================')
    print('\nNEW PROPERITES in %s' % fname2)  
    pp.pprint(set2 - set1)
    print('')

def main():
    parser = parse_args()
    args = parser.parse_args()

    f1 = args.file1
    f2 = args.file2

    diff_report(f1, f2)
    
if __name__== '__main__':
    main()
       
