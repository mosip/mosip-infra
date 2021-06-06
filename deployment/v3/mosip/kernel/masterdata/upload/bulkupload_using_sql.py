#!/usr/local/bin/python3
# Upload masterdata directly using SQL insert instead of Admin's bulk upload API. 
# This should be done only once in while seeding the DB.

import sys
import argparse
from api import *
from utils import *
import csv
import json
import pandas as pd
import config as conf
from datetime import datetime as dt
from sqlalchemy import create_engine

def get_order_from_list(files_file_name):
    table_order = []
    try:
        with open(files_file_name, 'r') as file:
            for line in file:
                l=line.strip()
                if not l.startswith('#'):
                    table_order.append(l)
    except:
        sys.exit('Table Order file not found ' + files_file_name + ' %tb')
    return table_order

def bulk_upload_csvs_using_sql(files, table_order):
    # with psycopg2.connect(host=conf.db_host,port=conf.db_port,database=conf.db_name,user=conf.db_user,password=conf.db_pwd) as conn:
    engine = create_engine('postgresql://%s:%s@%s:%s/%s' % (conf.db_user, conf.db_pwd, conf.db_host, conf.db_port, conf.db_name))
    for f in table_order:
        for fi in files:
            if f==os.path.basename(fi).split('.')[0]:
                myprint(fi)
                df = pd.read_csv(fi)
                df['cr_by'] = conf.superadmin_user
                df['cr_dtimes'] = str(dt.utcnow())
                df.to_sql(f,engine, index=False, if_exists='append')

def args_parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('path', help='directory containing all the tables in csv format')
    parser.add_argument('order', help='file that contains the table upload order')
    args = parser.parse_args()
    return args, parser

def main():
    args, parser =  args_parse()

    files = path_to_files(args.path)
    table_order = get_order_from_list(args.order)

    init_logger('full', 'a', './out.log', level=logging.INFO)  # Append mode
    init_logger('last', 'w', './last.log', level=logging.INFO, stdout=False)  # Just record log of last run

    bulk_upload_csvs_using_sql(files,table_order)

if __name__=="__main__":
    main()
