import subprocess
import os
import logging
import psycopg2
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

def init_db(dbnames, db_dict, passwords=None):
    '''
    Args:
        databases: dict {dbname : list of associated sql scripts}
        passwords:  Dictionary of various passwords used by DB. The key is
            the placeholder given in sql filies
    '''
    pwd = os.getcwd()    
    options = ''
    if passwords is not None:
        for key, value in passwords.items():
            options += "-v %s=\\'%s\\' " % (key, value)
    for dbname in dbnames:
        drop_db(dbname)   
        sql_paths = db_dict[dbname] 
        for sql_path in sql_paths:
            sql_file = os.path.basename(sql_path)
            os.chdir(os.path.dirname(sql_path))
            command('sudo -u postgres psql -f %s %s' % (sql_file, options))

    os.chdir(pwd) # Return back to where we started 
    restart_postgres()

def clean_table(dbname, table_name):
    import psycopg2
    '''
    Delete all entries from a table
    '''
    logger.info('Cleaning %s table' % table_name)
    logger.info("dbname=%s user=postgres" % dbname)
    conn = psycopg2.connect("dbname=%s user=postgres" % dbname)
    cur = conn.cursor()
    logger.info('delete from %s;' % table_name)
    cur.execute('delete from %s;' % table_name)
    conn.commit() 
    cur.close()
    conn.close()

def get_unique_machine_id(cur):
    '''
    Machine id is 5 digit numeric (although in string format). To assign a unique
    machine id, we find the largest number by querying table and then adding 1
    to it. 
    Args:
        cur:  Cursor of mosip_master db
    '''

    q = 'select id from machine_master order by id desc limit 1' 
    cur.execute(q)
    rows = cur.fetchall()
    if len(rows) == 0:
        return '10001'  # Default first machine id
    largest_id = rows[0][0]  # str
    largest_id_int = int(largest_id)
    new_id = largest_id_int + 1
    new_id_str = str(new_id)
    return new_id_str

def get_machine_id(cur, mac):
    '''
    get machine id given mac
    Returns:
        None if not found
    '''
    q = "select id from machine_master where mac_address=%s;"
    cur.execute(q, (mac,))
    rows = cur.fetchall()
    if len(rows) == 0:
        return None 
    else:
        return rows[0][0]
     
def add_umc(user_info, cur):
    '''
    Add User, Machine, Center info in various tables in DB.
    user_info:  UserInfo structure in common.py 
    cur: Cursor to mosip_master db. 

    CAUTION: If there is any conflict in insert, the insert is skipped, which
    means the row in not updated.
    TODO: Update the row with new data in case of conflict     
    '''
    u = user_info
    logger.info('Adding id=%s, name=%s, mac=%s, center=%s' % (u.uid, u.user_name, u.machine_mac, u.center_id)) 

    # Check if mac already exists
    machine_id = get_machine_id(cur, u.machine_mac)
    if machine_id is None:
        machine_id = get_unique_machine_id(cur)  # Assign machine id
    
    cur.execute("insert into machine_master (id, name, mac_address, serial_num, mspec_id, zone_code, lang_code, is_active, cr_by, cr_dtimes) values(%s, %s, %s, '000', '1001', %s, %s, 'true', 'superadmin', 'now()') on conflict do nothing;", (machine_id, u.machine_name, u.machine_mac, u.zone_code, u.lang_code)) 

    cur.execute("insert into machine_master_h (id, name, mac_address, serial_num, mspec_id, zone_code, lang_code, is_active, cr_by, cr_dtimes, eff_dtimes) values(%s, %s, %s, '000', '1001', %s, %s, 'true', 'superadmin', 'now()', 'now()') on conflict do nothing;", (machine_id, u.machine_name, u.machine_mac, u.zone_code, u.lang_code))

    # NOTE: User mobile is filled for uin
    cur.execute("insert into user_detail values (%s, %s, %s, %s, %s, 'ACT', %s, 'now()', 'PWD', 'true', 'superadmin', 'now()') on conflict do nothing;", (u.uid, u.user_mobile, u.user_name, u.user_email, u.user_mobile, u.lang_code))

    # NOTE: User mobile is filled for uin
    cur.execute("insert into user_detail_h (id, uin, name, email, mobile, status_code, lang_code, last_login_dtimes, last_login_method, is_active, cr_by, cr_dtimes, eff_dtimes) values (%s, %s, %s, %s, %s, 'ACT', %s, 'now()', 'PWD', 'true', 'superadmin', 'now()', 'now()') on conflict do nothing;", (u.uid, u.user_mobile, u.user_name, u.user_email, u.user_mobile, u.lang_code))

    cur.execute("insert into reg_center_user values(%s, %s, %s, 'true', 'superadmin', 'now()') on conflict do nothing;", (u.center_id, u.uid, u.lang_code)) 

    cur.execute("insert into reg_center_user_h (regcntr_id, usr_id, lang_code, is_active, cr_by, cr_dtimes, eff_dtimes) values(%s, %s, %s, 'true', 'superadmin', 'now()', 'now()') on conflict do nothing;", (u.center_id, u.uid, u.lang_code))

    cur.execute("insert into reg_center_machine values(%s, %s, %s, 'true', 'superadmin', 'now()') on conflict do nothing;", (u.center_id, machine_id, u.lang_code))

    cur.execute("insert into reg_center_machine_h (regcntr_id, machine_id, lang_code, is_active, cr_by, cr_dtimes, eff_dtimes) values(%s, %s, %s, 'true', 'superadmin', 'now()', 'now()') on conflict do nothing;", (u.center_id, machine_id, u.lang_code))

    cur.execute("insert into reg_center_user_machine values(%s, %s, %s, %s, 'true', 'superadmin', 'now()') on conflict do nothing;", (u.center_id, u.uid, machine_id, u.lang_code))

    cur.execute("insert into reg_center_user_machine_h (regcntr_id, usr_id, machine_id, lang_code, is_active, cr_by, cr_dtimes, eff_dtimes) values(%s, %s, %s, %s, 'true', 'superadmin', 'now()', 'now()') on conflict do nothing;", (u.center_id, u.uid, machine_id, u.lang_code))

def clear_umc_tables(cur):
    '''
    Clear all tables containing user, machine tables and their association
    with center.  
    '''
    logger.info('Clearing user, machine tables and their relation to centers')

    cur.execute("truncate machine_master cascade;")
    cur.execute("truncate machine_master_h cascade;")
    cur.execute("truncate user_detail cascade;")
    cur.execute("truncate user_detail_h cascade;")
    cur.execute("truncate reg_center_user cascade;")
    cur.execute("truncate reg_center_user_h cascade;")
    cur.execute("truncate reg_center_machine cascade;")
    cur.execute("truncate reg_center_machine_h cascade;")
    cur.execute("truncate reg_center_user_machine cascade;")
    cur.execute("truncate reg_center_user_machine_h cascade;")

def drop_db(dbname):
    import psycopg2
    '''
    '''
    logger.info('Dropping DB %s' % dbname) 
    conn = psycopg2.connect("dbname=postgres user=postgres")
    cur = conn.cursor()
    conn.autocommit = True
    cur.execute('drop database if exists %s;' % dbname)
    cur.close()
    conn.close()

def set_packet_retry_count(rid, count, cur):
    '''
    In the transaction table set retry count for packet to 'count'. Typically
    done while debugging a problem and you want to re-run the packet uploader
    stage
    cur: Cursor for mosip_regprc db.
    '''
    logger.info('Setting retry count for %s to %d' % (rid, count))
    q = "update registration set trn_retry_count=%s where id=%s;" 
    cur.execute(q, (count, rid)) 

def get_invalid_packets(cur, dtime):
    '''
    Args:
        cur: Cursor for mosip_regprc db
        dtime: Updated dtime for the sql script
    Returns: 
        List of rids of packets
    '''
    filtered = []
    q = "select id from registration where upd_dtimes> '"+dtime+"' and status_comment !='OSI Validation is Successful'"
    cur.execute(q)
    rows = cur.fetchall()
    for row in rows:
       filtered.append(row[0])

    return filtered
