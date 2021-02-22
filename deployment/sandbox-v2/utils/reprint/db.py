import psycopg2
from psycopg2.extras import RealDictCursor
import config as conf

class DatabaseSession:
    def __init__(self, host, port, user, pwd):
        self.host = host
        self.port = port
        self.user = user
        self.pwd = pwd
        self.idmap_conn = self.createConnection(host, port, user, pwd, 'mosip_idmap')
        self.idmap_conn.autocommit = True
        self.idrepo_conn = self.createConnection(host, port, user, pwd, 'mosip_idrepo')
        self.idrepo_conn.autocommit = True
        self.cred_conn = self.createConnection(host, port, user, pwd, 'mosip_credential')
        self.cred_conn.autocommit = True

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

    def getHash(self, modulo):
        cur = self.idrepo_conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("""
        select salt from uin_hash_salt where id=%s;
        """, [modulo])
        return cur.fetchone()

    def getRid(self, hash):
        cur = self.idrepo_conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("""
        select reg_id as rid from uin where uin_hash=%s;
        """, [hash])
        return cur.fetchone()

    def checkRequestInCredentialTransaction(self, req):
        cur = self.cred_conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("""
        select id from credential_transaction where request=%s and cr_dtimes > now() - INTERVAL '%s seconds';
        """, [req, conf.time_filter_in_seconds])
        return cur.fetchone()

    def closeAll(self):
        self.idrepo_conn.close()
        self.idmap_conn.close()
        self.cred_conn.close()
