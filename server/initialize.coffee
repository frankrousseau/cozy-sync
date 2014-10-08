controller = require './controllers/account'
WebDAVAccount = require './models/webdavaccount'

# creates the account the first time the application starts
module.exports = (callback) ->

    WebDAVAccount.first (err, account) ->
        # if no account has been created
        if not account?
            # we create one based on the code in the controller by mocking
            # express' req and res variables
            controller.createCredentials {}, send: callback