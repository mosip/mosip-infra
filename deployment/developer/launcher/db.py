import subprocess
import os
import logging
from common import *
from config import *

logger = logging.getLogger(__name__)

def install_postgres():
    logger.info('Installing postgres')
    command('sudo yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm')
    command('sudo yum -y install postgresql10')
    command('sudo yum -y install postgresql10-server')
    command('sudo /usr/pgsql-10/bin/postgresql-10-setup initdb')
    command('sudo systemctl enable postgresql-10')
    command('sudo systemctl start postgresql-10')
    configure_postgres()

def restart_postgres():
    logger.info('Restarting Postgres')
    command('sudo systemctl restart postgresql-10')

def configure_postgres():
    logger.info('Modify the pg_hba.conf file for "trust" access')
    command('sudo -u postgres mv %s/pg_hba.conf %s/pg_hba.conf.bak' % (PG_CONF_DIR, PG_CONF_DIR))
    command('sudo -u postgres cp resources/pg_hba.conf %s/pg_hba.conf' % PG_CONF_DIR)
    restart_postgres()

def init_db(db_scripts_path, sql_scripts, passwords=None):
    '''
    Args:
        passwords:  Dictionary of various passwords used by DB. The key is
            the placeholder given in sql filies
    '''
    pwd = os.getcwd()    
    os.chdir(db_scripts_path)
    options = ''
    if passwords is not None:
        for key, value in passwords.items():
            options += "-v %s=\\'%s\\' " % (key, value)
    for sql_path in sql_scripts:
        sql_dir = os.path.join(db_scripts_path, os.path.dirname(sql_path)) 
        sql_file = os.path.basename(sql_path)
        os.chdir(sql_dir)
        command('sudo -u postgres psql -f %s %s' % (sql_file, options))

    os.chdir(pwd) # Return back to where we started 
    restart_postgres()

def clean_table(dbname, table_name):
    import psycopg2
    '''
    Delete all entries from a table
    '''
    logger.info('Cleaning %s table' % table_name)
    print("dbname=%s user=postgres" % dbname)
    conn = psycopg2.connect("dbname=%s user=postgres" % dbname)
    cur = conn.cursor()
    print('delete from %s;' % table_name)
    cur.execute('delete from %s;' % table_name)
    conn.commit() 
    cur.close()
    conn.close()
     
