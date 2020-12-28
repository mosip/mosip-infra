import psycopg2

class DB: 
    def __init__(self, user, pwd, host, port, db_name):
        self.conn = psycopg2.connect(user = user, password = pwd, host = host, port = port, database = db_name) 
        self.cur = self.conn.cursor()
    
    def close(self):
        self.cur.close()
        self.conn.close()

    def insert_user_in_masterdb_sql(self, user_id, name, regcntr_id):
        cur = self.conn.cursor()
        try:
            cur.execute("insert into user_detail values (%s, '', %s, '', '', 'ACT', %s, 'eng', null, '', 'true', 'superadmin', now());", (user_id, name, regcntr_id)) 
        except psycopg2.errors.UniqueViolation:
            pass
        self.conn.commit()

    def insert_zone_user_map_in_masterdb_sql(self, user_id, zone_id):
        cur = self.conn.cursor()
        try:
            cur.execute("insert into zone_user values (%s, %s, 'eng', 'true', 'superadmin', now());" , 
                        (zone_id, user_id))
        except psycopg2.errors.UniqueViolation:
            pass
        self.conn.commit()

