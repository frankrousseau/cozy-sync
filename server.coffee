initialize = require './server/initialize'

application = module.exports = (callback) ->
    americano = require 'americano'

    options =
        name: 'sync'
        port: process.env.PORT or 9116
        host: process.env.HOST or "127.0.0.1"
        root: __dirname

    require('./server/models/webdavaccount').first ->
        americano.start options, (app, server) ->
            User = require './server/models/user'
            Realtimer = require 'cozy-realtime-adapter'
            realtime = Realtimer server : server, ['event.*']
            realtime.on 'user.*', -> User.updateUser()
            User.updateUser() # initialize User attributes.

            initialize ->
                callback app, server if callback?

if not module.parent
    application()
