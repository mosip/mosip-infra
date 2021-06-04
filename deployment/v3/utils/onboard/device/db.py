import psycopg2

class DB: 
    def __init__(self, user, pwd, host, port, db_name):
        self.conn = psycopg2.connect(user = user, password = pwd, host = host, port = port, database = db_name) 
        self.cur = self.conn.cursor()
    
    def close(self):
        self.cur.close()
        self.conn.close()

    def insert_spec_in_masterdb_sql(self, spec_id):
        cur = self.conn.cursor()
        try:
            cur.execute("insert into device_spec values (%s, 'xyz' , 'xyz', 'xyz', 'FRS', '1.0', 'xyz', 'eng', 'true', 'superadmin', now());" % (spec_id))
        except psycopg2.errors.UniqueViolation:
            pass
        self.conn.commit()

    def get_devices(self):
        cur = self.conn.cursor()
        cur.execute("select * from device_master;")
        return cur.fetchall()   
