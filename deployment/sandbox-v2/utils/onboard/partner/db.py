import psycopg2

class DB: 
    def __init__(self, user, pwd, host, port, db_name):
        self.conn = psycopg2.connect(user = user, password = pwd, host = host, port = port, database = db_name) 
        self.cur = self.conn.cursor()
    
    def close(self):
        self.cur.close()
        self.conn.close()

    def delete(self, tables):
        cur = self.conn.cursor()
        for table in tables: 
            r  = cur.execute("delete from %s" % table) 
            print('{0: <30}'.format(table), cur.statusmessage)
            self.conn.commit()
   

