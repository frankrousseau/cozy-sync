jsDAV = require "jsDAV"
jsDAV.debugMode = true

cozy_Auth_Backend           = require './backends/auth'

jsDAVACL_PrincipalCollection = require "jsDAV/lib/DAVACL/principalCollection"
cozy_PrincipalBackend        = require './backends/principal'
principalBackend             = new cozy_PrincipalBackend
nodePrincipalCollection      = jsDAVACL_PrincipalCollection.new(principalBackend)


jsCardDAV_AddressBookRoot    = require "jsDAV/lib/CardDAV/addressBookRoot"
cozy_CardBackend             = require './backends/carddav'
carddavBackend               = new cozy_CardBackend require './models/contact'
nodeCardDAV                  = jsCardDAV_AddressBookRoot.new(principalBackend, carddavBackend)


jsCalDAV_CalendarRoot        = require "jsDAV/lib/CalDAV/CalendarRoot"
cozy_CalBackend              = require './backends/caldav'
caldavBackend                = new cozy_CalBackend
    Alarm: require './models/alarm'
    Event: require './models/event'
    User:  require './models/user'
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


server = require('http').createServer (req, res) ->

    console.log 'URL IS', req.url

    if /^\/public/.test req.url
        # DAVServer reacted weirdly to /public -> /public/webdav by cozy-proxy
        req.url = req.url.replace '/public', '/public/webdav'
        DAVServer.exec req, res
    else
        res.writeHead 404
        res.end 'NOT FOUND'

server.listen 9116, "0.0.0.0", -> console.log "listenning"

# jsDAV.createServer options, 9116