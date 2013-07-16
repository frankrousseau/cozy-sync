jsDAV = require "jsdav"
jsDAV.debugMode = true

Db = require './backends/db'

jsDAV_Auth_Backend           = require './backends/auth'
jsDAVACL_PrincipalBackend    = require './backends/principal'
jsCardDAV_Backend            = require './backends/carddav'

jsDAVACL_PrincipalCollection = require("./node_modules/jsdav/lib/DAVACL/principalCollection");
jsCardDAV_AddressBookRoot    = require("./node_modules/jsdav/lib/CardDAV/addressBookRoot");

jsDAV_Auth_Plugin            = require("./node_modules/jsdav/lib/DAV/plugins/auth");
jsDAV_Browser_Plugin         = require("./node_modules/jsdav/lib/DAV/plugins/browser");
jsCardDAV_Plugin             = require("./node_modules/jsdav/lib/CardDAV/plugin");
jsDAVACL_Plugin              = require("./node_modules/jsdav/lib/DAVACL/plugin");

baseUri = '/public/'

authBackend      = new jsDAV_Auth_Backend Db
principalBackend = new jsDAVACL_PrincipalBackend Db
carddavBackend   = new jsCardDAV_Backend Db

nodes = [
    jsDAVACL_PrincipalCollection.new(principalBackend),
    jsCardDAV_AddressBookRoot.new(principalBackend, carddavBackend)
]

options = 
    node: nodes,
    baseUri: baseUri,
    authBackend: authBackend,
    realm: "jsDAV",
    plugins: [jsDAV_Auth_Plugin, jsDAV_Browser_Plugin, jsCardDAV_Plugin, jsDAVACL_Plugin]

jsDAV.createServer options, 9116