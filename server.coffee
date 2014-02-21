americano = require 'americano'

options =
    name: 'webdav'
    port: process.env.PORT or 9116
    host: process.env.HOST or "127.0.0.1"
    root: __dirname

if not module.parent
    americano.start options, (app) ->

        console.log "WebDAV Server listening on %s:%d within %s environment",
                    options.host, options.port, app.get('env')
