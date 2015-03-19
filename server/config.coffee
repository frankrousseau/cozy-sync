fs = require 'fs'
path = require 'path'
americano = require 'americano'
DAVServer = require './davserver'

# public path depends on what app is running (./server or ./build/server)
publicPath = __dirname + '/../client/public'
try
    fs.lstatSync publicPath
catch e
    publicPath = __dirname + '/../../client/public'

module.exports =

    common:
        set:
            views: path.join __dirname, 'views'
        use: [
            americano.static publicPath, maxAge: 86400000
            americano.bodyParser keepExtensions: true
            americano.logger 'dev'
            (req, res, next) ->
                return next null unless req.url.indexOf('/public') is 0
                req.url = req.url.replace '/public', '/public/sync'
                DAVServer.exec req, res
        ]
        useAfter: [
            americano.errorHandler
                dumpExceptions: true
                showStack: true
        ]

        engine:
            # Allows res.render of .js files (pre-rendered jade)
            js: (path, locals, callback) ->
                callback null, require(path)(locals)
    development: [
        americano.logger 'dev'
    ]

    production: [
        americano.logger 'short'
    ]

    plugins: [
        'americano-cozy'
    ]
