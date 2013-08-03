# -*- coding: utf-8 -*-

import web
import datetime

class UserRestHandler(web.RestHandler):
    def get(self, sn):
        sql = '''
        SELECT sn, no, name, idn, pwd, enrolled FROM suser
        '''
        with self.db_cursor() as dc:
            if sn :
                sn = int(sn)

                sql += " WHERE sn=%s"
                dc.execute(sql, [sn])
                self.write_json(dc.fetchone_dict())
            else:
                sql += 'ORDER BY enrolled, sn'
                dc.execute(sql)
                self.write_json(dc.fetchall_dicts())

    def post(self, sn):
        user = self.read_json()
        
        if not user.get('enrolled'):
            user['enrolled'] = datetime.date(2013, 1, 1)

        with self.db_cursor() as dc:
            sql = '''
            INSERT INTO suser 
                (no, name, idn, pwd, enrolled)
                VALUES(%s, %s, %s, %s, %s) RETURNING sn;
            '''
            dc.execute(sql, [user.get('no'), user.get('name'), 
                user.get('idn'), user.get('pwd'), user.get('enrolled')])
            sn = dc.fetchone()[0]
            user['sn']=sn
            self.write_json(user)

    def put(self, sn):
        user = self.read_json()

        if not user.get('enrolled'):
            user['enrolled'] = datetime.date(2013, 1, 1)

        with self.db_cursor() as dc:
            sql = ''' 
            UPDATE suser SET 
                no=%s, name=%s, idn=%s, pwd=%s,enrolled=%s
            WHERE sn=%s;
            '''
            dc.execute(sql, [user['no'], user['name'], user['idn'],
                user['pwd'], user['enrolled'], sn])

        self.write_json(user)

    def delete(self, sn):
        sn = int(sn)
        with self.db_cursor() as cur:
            sql = "DELETE FROM suser WHERE sn= %s"
            cur.execute(sql, [sn])
