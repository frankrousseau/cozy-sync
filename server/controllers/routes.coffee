account = require './account'

module.exports =
    '':
        get: account.index
    'token':
        post: account.createCredentials
