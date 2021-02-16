import psycopg2
from psycopg2.extras import RealDictCursor


class DatabaseSession:
    def __init__(self, host, port, user, pwd):
        self.host = host
        self.port = port
        self.user = user
        self.pwd = pwd
        self.idmap_conn = self.createConnection(host, port, user, pwd, 'mosip_idmap')
        self.idmap_conn.autocommit = True

    @staticmethod
    def createConnection(host, port, user, pwd, db):
        return psycopg2.connect(
            host=host,
            port=port,
            database=db,
            user=user,
            password=pwd
        )

    def getVids(self):
        cur = self.idmap_conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("""
        select vid from vid where vidtyp_code=%s and expiry_dtimes>now() and status_code=%s;
        """, ['PERPETUAL', 'ACTIVE'])
        return cur.fetchall()
