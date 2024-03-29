#!/usr/local/bin/python3
# Python script to convert csv files to excel files.

import os
import sys
import pandas as pd
import argparse
import traceback

def args_parse():
   parser = argparse.ArgumentParser()
   parser.add_argument('input_csv', help='Path of input csv')
   parser.add_argument('output_xlsx', help='Path of output xlsx')
   args = parser.parse_args()
   return args, parser

def main():
    args, parser =  args_parse()
    try:
        pd.read_csv(args.input_csv, error_bad_lines=False).to_excel(args.output_xlsx, index=None)
    except:
        formatted_lines = traceback.format_exc()
        print(formatted_lines)
        sys.exit(1)
    return sys.exit(0)

if __name__ == "__main__":
    main()
