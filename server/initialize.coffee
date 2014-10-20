controller = require './controllers/account'
WebDAVAccount = require './models/webdavaccount'

# creates the account the first time the application starts
module.exports = (callback) ->

    # tests initialize the credentials their way
    if process.env.NODE_ENV is 'test'
        callback()
    else
        WebDAVAccount.first (err, account) ->
            # if no account has been created
            WebDAVAccount.createAccount callback unless account?
