import psycopg2

class DB: 
    def __init__(self, user, pwd, host, port, db_name):
        self.conn = psycopg2.connect(user = user, password = pwd, host = host, port = port, database = db_name) 
        self.cur = self.conn.cursor()
        print(self.cur)
    
