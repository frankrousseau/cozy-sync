jsDAV = require "jsDAV"
jsDAV.debugMode = true

Db = require './models/db'


jsDAV_Auth_Backend           = require './backends/auth'
jsDAVACL_PrincipalBackend    = require './backends/principal'
jsCardDAV_Backend            = require './backends/carddav'

jsCardDAV_AddressBookRoot    = require "jsDAV/lib/CardDAV/addressBookRoot"
jsDAVACL_PrincipalCollection = require "jsDAV/lib/DAVACL/principalCollection"

jsDAV_Auth_Plugin            = require "jsDAV/lib/DAV/plugins/auth"
jsDAV_Browser_Plugin         = require "jsDAV/lib/DAV/plugins/browser"
jsCardDAV_Plugin             = require "jsDAV/lib/CardDAV/plugin"
jsDAVACL_Plugin              = require "jsDAV/lib/DAVACL/plugin"

baseUri = '/public/'

authBackend      = new jsDAV_Auth_Backend
principalBackend = new jsDAVACL_PrincipalBackend
carddavBackend   = new jsCardDAV_Backend require './models/contact'

nodes = [
    jsDAVACL_PrincipalCollection.new(principalBackend),
    jsCardDAV_AddressBookRoot.new(principalBackend, carddavBackend)
]

options = 
    node: nodes,
    baseUri: baseUri,
    authBackend: authBackend,
    realm: "jsDAV",
    plugins: [jsDAV_Auth_Plugin, jsCardDAV_Plugin, jsDAVACL_Plugin]

jsDAV.createServer options, 9116