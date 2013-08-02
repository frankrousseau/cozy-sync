# Interface = require 'jsdav/lib/CardDAV/interfaces/iBackend'
Exc = require 'jsDAV/lib/shared/exceptions'
BasicAuth = require 'jsDAV/lib/DAV/plugins/auth/abstractBasic'
WebDAVAccount = require '../models/webdavaccount'

module.exports = BasicAuth.extend

    validateUserPass: (username, password, cbvalidpass) ->
        WebDAVAccount.first (err, account) ->
            result = not err and account? and account.password is password
            console.log 'AUTH RESULT :' + result

            cbvalidpass = result
