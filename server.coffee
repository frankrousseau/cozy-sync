americano = require 'americano'

jsDAV = require "cozy-jsdav-fork"
jsDAV.debugMode = true unless process.env.NODE_ENV is 'test'

# Auth
cozy_Auth_Backend = require './server/backends/auth'

# Permissions
jsDAVACL_PrincipalCollection = require "cozy-jsdav-fork/lib/DAVACL/principalCollection"
cozy_PrincipalBackend = require './server/backends/principal'
principalBackend = new cozy_PrincipalBackend
nodePrincipalCollection = jsDAVACL_PrincipalCollection.new(principalBackend)

# Contacts
jsCardDAV_AddressBookRoot = require "cozy-jsdav-fork/lib/CardDAV/addressBookRoot"
cozy_CardBackend = require './server/backends/carddav'
carddavBackend = new cozy_CardBackend require './server/models/contact'
nodeCardDAV = jsCardDAV_AddressBookRoot.new(principalBackend, carddavBackend)

# Calendar
Event = require './server/models/event'
Alarm = require './server/models/alarm'
User = require './server/models/user'
jsCalDAV_CalendarRoot        = require "cozy-jsdav-fork/lib/CalDAV/calendarRoot"
cozy_CalBackend = require './server/backends/caldav'
caldavBackend  = new cozy_CalBackend Event, Alarm, User
nodeCalDAV = jsCalDAV_CalendarRoot.new(principalBackend, caldavBackend)


# Init DAV Server
DAVServer = jsDAV.mount
    server: true
    standalone: false

    realm: 'jsDAV'
    mount: '/public/webdav/'

    authBackend: cozy_Auth_Backend.new()
    plugins: [
        require "cozy-jsdav-fork/lib/DAV/plugins/auth"
        require "cozy-jsdav-fork/lib/CardDAV/plugin"
        require "cozy-jsdav-fork/lib/CalDAV/plugin"
        require "cozy-jsdav-fork/lib/DAVACL/plugin"
    ]

    node: [nodePrincipalCollection, nodeCardDAV, nodeCalDAV]


port = process.env.PORT || 9116
host = process.env.HOST || "127.0.0.1"

americano.start name: 'webdav', port: port, (app) ->

    # /public is the WebDAV server
    app.use '/public', (req, res) ->
        # jsDAV need to know the true client url
        req.url = "/public/webdav#{req.url}"
        DavServer.exec req, res

    console.log "WebDAV Server listening on %s:%d within %s environment",
                host, port, app.get('env')
