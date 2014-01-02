americano = require 'americano-cozy'

# Object required to store the automatically generated webdav credentials.
module.exports = WebDAVAccount = americano.getModel 'WebDAVAccount',
    id: String
    login: String
    password: String

WebDAVAccount.first = (callback) ->
    WebDAVAccount.request 'all', (err, accounts) ->
        if err then callback err
        else if not accounts or accounts.length is 0 then callback null, null
        else  callback null, accounts[0]
