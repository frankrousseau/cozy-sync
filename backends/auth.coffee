# Interface = require 'jsdav/lib/CardDAV/interfaces/iBackend'
Exc       = require 'jsDAV/lib/shared/exceptions'
BasicAuth = require 'jsDAV/lib/DAV/plugins/auth/abstractBasic'

module.exports = BasicAuth.extend

    # @TODO actualy check this
    validateUserPass: (username, password, cbvalidpass) -> cbvalidpass true
