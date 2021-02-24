import psycopg2

class DB: 
    def __init__(self, user, pwd, host, port, db_name):
        self.conn = psycopg2.connect(user = user, password = pwd, host = host, port = port, database = db_name) 
    
    def close(self):
        self.conn.close()

    def get_rids(self, query):
        cur = self.conn.cursor()
        cur.execute(query)
        rids = cur.fetchall()   
        cur.close()
        return rids


