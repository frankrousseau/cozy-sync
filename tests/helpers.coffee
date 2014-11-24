TESTPORT = 8888
PASSWORD = 'test'

request = require 'request'
async   = require 'async'

if process.env.USE_JS
    exports.prefix = '../build/'
else
    exports.prefix = '../'

initializeApplication = require "#{exports.prefix}server"

exports.TESTPORT = TESTPORT

exports.startServer = (done) ->
    @timeout 5000
    process.env.PORT = TESTPORT
    initializeApplication (app, server) =>
        @server = server
        done()

exports.prepareForCrypto = (done) ->
    # don't want to include bcrypt
    clear = "password"
    salt = "th00ee2l2w23ayvi2njpwm1n"
    hash = "$2a$10$sKO5HTT58LhMFywFKLKFx.//q.MzNwwlLvdKVBePP4P8uv7igimD6"
    request.post
        url: 'http://localhost:9101/user/'
        auth: user: 'proxy', pass: 'token'
        json:
            email: 'test@example.com'
            owner: true
            salt: salt
            docType: 'User'
            password: hash
            timezone: 'Europe/Paris'
    , (err, res, user) ->
        request.post
            auth: user: 'proxy', pass: 'token'
            url: 'http://localhost:9101/accounts/password/'
            json: password: clear
        , (err, res, result) ->
            done err

exports.makeDAVAccount = (done) ->
    @timeout 25000
    exports.prepareForCrypto (err) ->
        if err
            console.log "FAIL TO PREPARE CRYPTO", err
            return done err
        WebDAVAccount = require "#{exports.prefix}server/models/webdavaccount"
        data = login: 'me', password: PASSWORD
        WebDAVAccount.create data, done

exports.createContact = (name) -> (done) ->
    Contact = require "#{exports.prefix}server/models/contact"
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
    Event = require "#{exports.prefix}server/models/event"
    start = new Date 2013, 11, start, 10, 0, 0
    end = new Date start.getTime() + 7200000
    data =
        start:       start.toString()
        end:         end.toString()
        place:       description
        details:     description
        description: title
        tags: ['my-calendar']

    Event.create data, (err, doc)  =>
        @events ?= {}
        @events[title] = doc
        done err

exports.createRequests = (done) ->
    @timeout 10000
    root = require('path').join __dirname, exports.prefix
    require('americano-cozy').configure root, null, (err) ->
        done err

exports.cleanDB = (done) ->
    @timeout 10000

    requests =
        'event':         'byURI'
        'contact':       'byURI'
        'user':          'all'
        'cozyinstance':  'all'

    ops = Object.keys(requests).map (name) -> (cb) ->
        model = require "#{exports.prefix}server/models/#{name}"
        model.requestDestroy requests[name], cb

    # need to tmp this a bit as davaccount changes when other docs are deleted
    deleteWebdavaccout = ->
        DAVAccount = require "#{exports.prefix}server/models/webdavaccount"
        DAVAccount.requestDestroy 'all', done

    async.series ops, (err) ->
        setTimeout deleteWebdavaccout, 2000



exports.closeServer = (done) ->
    @timeout 5000
    @server.close done

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
