#!/usr/bin/python3.6
# Script to clean up Reg Proc tables for testing

import psycopg2
def clean_table(dbname, table_name):
    '''
    '''
    print('Cleaning %s table' % table_name)
    print("dbname=%s user=postgres" % dbname)
    conn = psycopg2.connect("dbname=%s user=postgres" % dbname)
    cur = conn.cursor()
    print('delete from %s;' % table_name)
    cur.execute('delete from %s;' % table_name)
    conn.commit()
    cur.close()
    conn.close()


clean_table('mosip_regprc', 'registration_list')
clean_table('mosip_regprc', 'registration_transaction')
clean_table('mosip_regprc', 'registration')
