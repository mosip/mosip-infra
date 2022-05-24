#!/usr/local/bin/python3
# Upload masterdata directly using SQL insert instead of Admin's bulk upload API. 
# This should be done only once in while seeding the DB first time.

import sys
import argparse
from api import *
from utils import *
import json
import pandas as pd
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

def upload_xlsx(files, table_order, admin_user, db_user, db_pwd, db_host, db_port):
    engine = create_engine('postgresql://%s:%s@%s:%s/%s' % (db_user, db_pwd, db_host, db_port, 'mosip_master'))
    for table in table_order:
        for fi in files:
            if table==os.path.basename(fi).split('.')[0]:
                myprint(fi)
                df = pd.read_excel(fi, dtype={'apptyp_code' : str})
                df['cr_by'] = admin_user
                df['cr_dtimes'] = str(dt.utcnow())
                engine.execute('TRUNCATE TABLE %s CASCADE;' % table)
                df.to_sql(table, engine, index=False, if_exists='append')

def args_parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('db_host', help='db host name/ip address')
    parser.add_argument('db_pwd', help='db host name/ip address')
    parser.add_argument('user', help='Admin username (as in IAM) of executor of this script')
    parser.add_argument('xls_folder', help='directory containing all the tables in xlsx format')
    parser.add_argument('--tables_file', type=str, default='table_order', help='File containing tables that need to be initiazed with the right order')
    parser.add_argument('--db_user', help='Db supseradmin user role for masterdb. Default: postgres', type=str,
                        default='postgres')
    parser.add_argument('--db_port', help='db port. Default is 5432', type=int, default=5432)
    args = parser.parse_args()
    return args, parser

def main():
    args, parser =  args_parse()

    files = path_to_files(args.xls_folder)
    table_order = get_order_from_list(os.path.join(sys.path[0], args.tables_file))

    init_logger('full', 'a', './out.log', level=logging.INFO)  # Append mode

    upload_xlsx(files, table_order, args.user, args.db_user, args.db_pwd, args.db_host, args.db_port)

if __name__=="__main__":
    main()
