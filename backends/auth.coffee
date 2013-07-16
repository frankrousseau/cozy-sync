# Interface = require 'jsdav/lib/CardDAV/interfaces/iBackend'
Exc       = require 'jsdav/lib/shared/exceptions'
BasicAuth = require 'jsdav/lib/DAV/plugins/auth/abstractBasic'

handle (err) ->
    console.log err
    return new Exc err.message || err

module.exports = Basic.extends

    # @TODO actualy check this
    validateUserPass: (username, password, cbvalidpass) -> cbvalidpass true
