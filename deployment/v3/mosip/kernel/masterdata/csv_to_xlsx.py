#!/usr/local/bin/python3

import os
import sys
import pandas as pd
from utils import *

def csv_to_xlsx(path_to_csv_dir,path_to_xlsx_dir):
    files=path_to_files(path_to_csv_dir)
    files_xlsx=[]
    for i in range(len(files)):
        # print('%d. '%(i+1) + files[i])
        fname = files[i]
        fi = fname.split('.')
        fi[-1] = 'xlsx'
        fname = '.'.join(fi)
        fi = fname.split('/')
        fi[0] = path_to_xlsx_dir
        fname = '/'.join(fi)
        pd.read_csv(files[i]).to_excel(fname,index=None)

if __name__ == "__main__":
    csv_to_xlsx('csvData','csvDataXlsx')
