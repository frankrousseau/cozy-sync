
TESTPORT = 888

exports.TESTPORT = TESTPORT
exports.before = (done) ->
    app = require('../server')

    app.start TESTPORT, (err) ->
        if err
            console.log "Failled to start app"
            console.log err.stack
            process.exit 1
        else
            console.log "WebDAV Server listening on %s:%d within %s environment",
                        host, port, app.get('env')
