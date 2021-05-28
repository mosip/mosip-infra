# Python script to convert csv files to excel files by removing:
#   - optional columns(cr_by | cr_dtimes | upd_by | upd_dtimes | is_deleted | del_dtimes)
#   - Arabic language

#!/usr/local/bin/python3

import os
import sys
import pandas as pd
import argparse
from utils import *

def csv_to_xlsx(path_to_csv_dir, path_to_xlsx_dir):
    files = path_to_files(path_to_csv_dir)
    files_xlsx = path_to_xlsx_dir
    for i in range(len(files)):
        data = pd.read_csv(files[i], error_bad_lines=False)
        files[i] = files[i].replace("master-","") #removing prefix-master from csv files
        # to delete columns
        drop_list = ['cr_by', 'cr_dtimes', 'upd_by', 'upd_dtimes', 'is_deleted', 'del_dtimes']
        for j in drop_list:
            if j in data.columns:
                data.drop(j, inplace=True, axis=1)

        #to delete lang_code:ara
        try:
            data = data.set_index('lang_code')
            data = data.drop('ara', axis=0)
        except:
            pass 
        filename = (files[i].replace('csv','')+'xlsx').replace(path_to_csv_dir+'/', '')
        path = os.path.join(files_xlsx, os.path.basename(filename))
        data.to_excel(path)

def args_parse():
   parser = argparse.ArgumentParser()
   parser.add_argument('csv_files', help='directory containing csv files | input files')
   parser.add_argument('xlsx_files', help='directory containing xlsx files | output files')
   args = parser.parse_args()
   return args, parser

def main():
    args, parser =  args_parse()
    init_logger('full', 'a', './out.log', level=logging.INFO)
    try:
        csv_path = args.csv_files
        xlsx_path = args.xlsx_files
        csv_to_xlsx(csv_path, xlsx_path)
    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    return sys.exit(0)

if __name__ == "__main__":
    main()
