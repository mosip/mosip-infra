#!/usr/local/bin/python3

# Python script for csv files to remove:
#   - optional columns(cr_by | cr_dtimes | upd_by | upd_dtimes | is_deleted | del_dtimes)
#   - Arabic language

import os
import sys
import pandas as pd
import argparse
from utils import *

def csv_del_data(path_to_csv_dir, path_to_res_dir):
    files = path_to_files(path_to_csv_dir)
    files_res = path_to_res_dir
    for i in range(len(files)):
        data = pd.read_csv(files[i], error_bad_lines=False)
        files[i] = files[i].replace("master-","") #removing prefix master from csv files

        data.columns = data.columns.str.lower()

        # to delete columns
        drop_list = ['cr_by', 'cr_dtimes', 'upd_by', 'upd_dtimes', 'is_deleted', 'del_dtimes', 'job_type']
        for j in drop_list:
            if j in data.columns:
                data.drop(j, inplace=True, axis=1)

        #to delete lang_code:ara
        try:
            data = data.set_index('lang_code')
            data = data.drop('ara', axis=0)
        except:
            pass
        path = os.path.join(files_res, os.path.basename(files[i]))
        data.to_csv(path)

def args_parse():
   parser = argparse.ArgumentParser()
   parser.add_argument('csv_files', help='directory containing csv files | input files')
   parser.add_argument('res_files', help='directory containing resultant files | output files')
   args = parser.parse_args()
   return args, parser

def main():
    args, parser =  args_parse()
    init_logger('full', 'a', './out.log', level=logging.INFO)
    try:
        csv_path = args.csv_files
        res_path = args.res_files
        csv_del_data(csv_path, res_path)
    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    return sys.exit(0)

if __name__ == "__main__":
    main()
