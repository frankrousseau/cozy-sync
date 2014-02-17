TESTPORT = 8888
PASSWORD = 'test'

request = require 'request'
async   = require 'async'
americano = require 'americano'

exports.TESTPORT = TESTPORT

exports.startServer = (done) ->
    console.log "WE TRY TO START"
    @timeout 5000
    options =
        port: TESTPORT
        name: "Test Contacts"
    americano.start options, (app, server) =>
        @server = server
        done()

exports.prepareForCrypto = (done) ->
    request.post
        url: 'http://localhost:9101/user'
        auth: user: 'proxy', pass: 'token'
        json: password: 'testpass', timezone: 'Europe/Paris'
    , (err, user) ->
        console.log "USER CREATION ERRROR : ", err
        request.post
            url: 'http://localhost:9101/account/password'
            json: password: 'testpass'
        , (err, result) ->
            console.log "KEYS INIT ERRROR", err
            done err

exports.makeDAVAccount = (done) ->
    exports.prepareForCrypto (err) ->
        if err
            console.log "FAIL TO PREPARE CRYPTO", err
            return done err
        WebDAVAccount = require '../server/models/webdavaccount'
        data = login: 'me', password: PASSWORD
        WebDAVAccount.create data, done

exports.createContact = (name) -> (done) ->
    Contact = require '../server/models/contact'
    sampleaddress = 'Box3;Suite215;14 Avenue de la République;Compiègne;Picardie;60200;France'
    data =
        fn: name
        note: "some stuff about #{name}"
        datapoints: [
            {name: 'tel'  , type: 'home', value: '000'}
            {name: 'tel'  , type: 'work', value: '111'}
            {name: 'email', type: 'home', value: "#{name.toLowerCase()}@test.com"}
            {name: 'adr'  , type: 'home', value: sampleaddress}
        ]
    Contact.create data, (err, doc)  =>
        @contacts ?= {}
        @contacts[name] = doc
        done err

exports.createEvent = (title, description, start) -> (done) ->
    Event = require '../server/models/event'
    start = new Date 2013, 11, start, 10, 0, 0
    end = new Date start.getTime() + 7200000
    data =
        start:       start.toString()
        end:         end.toString()
        place:       description
        details:     description
        description: title

    Event.create data, (err, doc)  =>
        @events ?= {}
        @events[title] = doc
        done err

exports.createRequests = (done) ->
    root = require('path').join __dirname, '..'
    require('americano-cozy').configure root, null, (err) ->
        exports.createRequests = (cb) -> cb()
        done err


exports.cleanDB = (done) ->
    @timeout 5000

    models =
        'event':         'byURI'
        'alarm':         'byURI'
        'contact':       'byURI'
        'webdavaccount': 'all'
        'user':          'all'
        'cozyinstance':  'all'

    ops = []

    for model, requestname of models
        do (model, requestname) ->
            ops.push (cb) ->
                model = require "../server/models/#{model}"
                model.requestDestroy requestname, cb

    exports.createRequests (err) ->
        console.log "WE GET HERE"
        return done err if err
        async.series ops, done

exports.closeServer = (done) ->
    @server.close()
    done()

exports.after = exports.cleanDB

exports.send = (method, path, body, head) ->
    (done) ->
        headers = connection: 'close', 'content-length': new Buffer(body, 'utf8').length
        headers[name] = value for name, value of head
        url = "http://localhost:#{TESTPORT}#{path}"
        auth =
          user: 'me',
          pass: PASSWORD,
          sendImmediately: true
        pool = false

        options = {method, url, body, headers, auth, pool}
        req = request options, (err, res, resbody) =>
            console.log 'REQUEST DROPPED AN ERROR :', err if err
            @err = err
            @res = res
            @resbody = resbody
            done()
