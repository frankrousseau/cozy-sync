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
            'view engine': 'jade'
            views: './server/views'
        use: [
            americano.static publicPath, maxAge: 86400000
            americano.bodyParser keepExtensions: true
            americano.logger 'dev'
            americano.errorHandler
                dumpExceptions: true
                showStack: true
            (req, res, next) ->
                return next null unless req.url.indexOf('/public') is 0
                req.url = req.url.replace '/public', '/public/sync'
                DAVServer.exec req, res
        ]
    development: [
        americano.logger 'dev'
    ]

    production: [
        americano.logger 'short'
    ]

    plugins: [
        'americano-cozy'
    ]
