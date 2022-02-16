#!/usr/local/bin/python3
# Create topics needed for regproc

import sys
import argparse
import json
import pandas as pd
from datetime import datetime as dt
from sqlalchemy import create_engine

def upload_xlsx(xls_path, admin_user, db_user, db_pwd, db_host, db_port):
    engine = create_engine('postgresql://%s:%s@%s:%s/%s' % (db_user, db_pwd, db_host, db_port, 'mosip_websub'))
    fp = open(xls_path, 'rb')
    df = pd.read_excel(fp)
    df['cr_by'] = admin_user
    df['cr_dtimes'] = str(dt.utcnow())
    df.to_sql('topic', engine, index=False, if_exists='append')

def args_parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('db_host', help='db host name/ip address')
    parser.add_argument('db_pwd', help='db host name/ip address')
    parser.add_argument('user', help='Admin username (as in IAM) of executor of this script')
    parser.add_argument('xls', help='Excel file containing topics')
    parser.add_argument('--db_user', help='Websub db admin user role for masterdb. Default: websubuser', type=str,
                        default='websubuser')
    parser.add_argument('--db_port', help='db port. Default is 5432', type=int, default=5432)
    args = parser.parse_args()
    return args, parser

def main():
    args, parser =  args_parse()
    upload_xlsx(args.xls, args.user, args.db_user, args.db_pwd, args.db_host, args.db_port)

if __name__=="__main__":
    main()
