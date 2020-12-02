#!/bin/python3
# Script to analyse the DB packet info  

from db import *
import config as conf

class App:
    def __init__(self, conf):
        self.db =  DB(conf.db_user, conf.db_pwd, conf.db_host, conf.db_port, 'mosip_regprc') 
        self.start_stage = 'PACKET_RECEIVER'
        self.end_stage = 'UIN_GENERATOR'

    def get_regids(self): 
        cur = self.db.conn.cursor()
        cur.execute('select distinct reg_id from registration_transaction;') 
        rows = cur.fetchall() 
        reg_ids = [x[0] for x in rows]
        cur.close() 
        return reg_ids 

    def get_time(self, reg_id, stage):
        '''
        Get timestamp of a stage, reg_id.
        Returns None if not found. 
        '''  
        cur = self.db.conn.cursor()
        cur.execute("select upd_dtimes from registration_transaction where reg_id=%s and trn_type_code=%s", 
                            (reg_id, stage))
        rows = cur.fetchall() 
        r = None
        if len(rows) > 0:
            r = rows[0][0] 
        cur.close()
        return r

    def valid_reg_ids(self):
        reg_ids = self.get_regids()       
        valid = []
        invalid = []
        for reg_id in reg_ids:
            start_time = self.get_time(reg_id, self.start_stage)           
            if start_time is None: 
                invalid.append(reg_id)
                continue
            end_time = self.get_time(reg_id, self.end_stage)       
            if end_time is None: 
                invalid.append(reg_id)
                continue
            valid.append(reg_id)

        return len(valid), len(reg_ids), invalid

def main():

    app = App(conf) 
    nvalid, ntotal, invalids = app.valid_reg_ids()
    print('valid regids= %d / %d' % (nvalid, ntotal))
    for invalid in invalids:
        print(invalid)

if __name__=="__main__":
    main()


