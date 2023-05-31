#!/usr/bin/python3
# This script compares two properties files. Reports missing, common, and
# different properties

import argparse
import csv
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

def write_to_csv(filename, properties):
    with open(filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['Key', 'Value'])
        for key, value in properties.items():
            writer.writerow([key, value])

def diff_report(fname1, fname2):
    pp = pprint.PrettyPrinter(indent=0)
    props1 = read_props(fname1)
    props2 = read_props(fname2)
    set1 = set(props1.keys())
    set2 = set(props2.keys())

    # Find out common properties with different value
    common = set1.intersection(set2)
    different_properties = {}
    for k in common:
        v1 = props1[k].strip()
        v2 = props2[k].strip()
        if v1 != v2:
            different_properties[k] = {'Value1': v1, 'Value2': v2}

    properties_file1_only = {k: props1[k] for k in set1 - set2}
    properties_file2_only = {k: props2[k] for k in set2 - set1}

    # Write properties with different values to CSV
    write_to_csv('different_properties.csv', different_properties)

    # Write properties present in the first file only to CSV
    write_to_csv('properties_file1_only.csv', properties_file1_only)

    # Write properties present in the second file only to CSV
    write_to_csv('properties_file2_only.csv', properties_file2_only)

def main():
    parser = parse_args()
    args = parser.parse_args()

    f1 = args.file1
    f2 = args.file2

    diff_report(f1, f2)

if __name__ == '__main__':
    main()