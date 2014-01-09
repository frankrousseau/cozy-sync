TESTPORT = 8888
PASSWORD = 'test'

request = require 'request'
async   = require 'async'
americano = require 'americano'

exports.TESTPORT = TESTPORT

DavServer = require '../server'

exports.startServer = (done) ->
    @timeout 5000
    options =
        port: TESTPORT
        name: "Test Contacts"
    americano.start options, (app, server) =>
        app.use '/public', (req, res) ->
             req.url = "/public/webdav#{req.url}"
             DavServer.exec req, res
        @server = server
        done()

exports.makeDAVAccount = (done) ->
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

exports.cleanDB = (done) ->
    @timeout 5000

    models =
        'event':         'byURI'
        'alarm':         'byURI'
        'contact':       'byURI'
        'webdavaccount': 'all'
        'user':          'all'
        'cozyinstance': 'all'

    ops = []

    addOp = (model, requestname) ->
        ops.push (cb) ->
            model = require "../server/models/#{model}"
            model.requestDestroy requestname, cb

    for model, requestname of models
        addOp model, requestname

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
