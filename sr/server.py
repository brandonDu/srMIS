# -*- coding: utf-8 -*-

import tornado.ioloop
import tornado.web

import os
import web
import dbconn
dbconn.register_dsn("host=localhost dbname=srdb user=srdbo password=pass")

from handlers import *

settings = {
    "static_path": os.path.join(os.getcwdu(), 'pages'),
    "debug": True
}

handlers = [
    (r"/s/user/([0-9]+)?", UserRestHandler),
    (r'/(.*)', web.HtplHandler)
]

application = tornado.web.Application(handlers, **settings)


if __name__ == "__main__":
    import logging
    logging.basicConfig(
        format='%(asctime)s %(name)s:%(levelname)s:%(message)s', 
        datefmt='%H%M%S', level=logging.DEBUG)

    application.listen(8888)
    server = tornado.ioloop.IOLoop.instance()
    #tornado.ioloop.PeriodicCallback(lambda: None, 500, server).start()
    server.start()

