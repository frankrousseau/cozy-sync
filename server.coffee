application = module.exports = (callback) ->
    americano = require 'americano'

    options =
        name: 'webdav'
        port: process.env.PORT or 9116
        host: process.env.HOST or "127.0.0.1"
        root: __dirname

    require('./server/models/webdavaccount').first ->
        americano.start options, (app, server) ->
            callback app, server if callback?

if not module.parent
    application()
