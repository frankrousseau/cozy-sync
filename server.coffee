jsDAV = require "jsDAV"
jsDAV.debugMode = true

cozy_Auth_Backend            = require './backends/auth'

jsDAVACL_PrincipalCollection = require "jsDAV/lib/DAVACL/principalCollection"
cozy_PrincipalBackend        = require './backends/principal'
principalBackend             = new cozy_PrincipalBackend
nodePrincipalCollection      = jsDAVACL_PrincipalCollection.new(principalBackend)


jsCardDAV_AddressBookRoot    = require "jsDAV/lib/CardDAV/addressBookRoot"
cozy_CardBackend             = require './backends/carddav'
carddavBackend               = new cozy_CardBackend require './models/contact'
nodeCardDAV                  = jsCardDAV_AddressBookRoot.new(principalBackend, carddavBackend)


jsCalDAV_CalendarRoot        = require "jsDAV/lib/CalDAV/calendarRoot"
cozy_CalBackend              = require './backends/caldav'
caldavBackend                = new cozy_CalBackend require './models/calendar'
nodeCalDAV                   = jsCalDAV_CalendarRoot.new(principalBackend, caldavBackend)


DAVServer = jsDAV.mount
    server: true
    standalone: false

    realm: 'jsDAV'
    mount: '/public/webdav/'

    authBackend: cozy_Auth_Backend.new()
    plugins: [
        require "jsDAV/lib/DAV/plugins/auth"
        require "jsDAV/lib/CardDAV/plugin"
        require "jsDAV/lib/CalDAV/plugin"
        require "jsDAV/lib/DAVACL/plugin"
    ]

    node: [nodePrincipalCollection, nodeCardDAV, nodeCalDAV]



shortId = require 'shortid'
express = require 'express'
WebDAVAccount = require './models/webdavaccount'

app = express()
app.set 'view engine', 'jade'
app.use express.static(__dirname + '/public')
app.use express.logger 'dev'
app.use express.errorHandler
    dumpExceptions: true
    showStack: true

# Index page
app.get '/', (req, res) ->
    WebDAVAccount.first (err, account) ->
        if err
            next err
        else if not account?
            res.render 'index'
        else
            res.render 'index', account.toJSON()

# Get credentials
app.get '/token', (req, res) ->
    WebDAVAccount.first (err, account) ->
        if err
            res.send error: true, msg: err.toString(), 500
        else if not account?
            res.send error: true, msg: 'No webdav account generated', 404
        else
            res.send account.toJSON()

# Generate credentials
app.post '/token', (req, res) ->
    login = 'me'
    password = shortId.generate()
    data = login: login, password: password

    WebDAVAccount.first (err, account) ->
        if err
            res.send error: true, msg: err.toString(), 500
        else if not account?
            WebDAVAccount.create data, (err, account) ->
                if err then res.send error: true, msg: err.toString(), 500
                else res.send success: true, account: account.toJSON()
        else
            account.login = login
            account.password = password
            account.save (err) ->
                if err then res.send error: true, msg: err.toString(), 500
                else res.send success: true, account: account.toJSON()


app.propfind '*', (req, res) ->
    if /^\/public/.test req.url
        req.url = req.url.replace '/public', '/public/webdav'
        DAVServer.exec req, res
    else
        res.send error: true, msg: 'Path not found', 404


port = process.env.PORT || 9116
host = process.env.HOST || "0.0.0.0"

app.listen port, host, ->
    console.log "WebDAV Server listening on %s:%d within %s environment",
                host, port, app.get('env')
