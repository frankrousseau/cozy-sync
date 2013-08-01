shortId = require 'shortid'
express = require 'express'
WebDAVAccount = require './models/webdavaccount'


module.exports = (davServer) ->
    app = express()
    app.set 'view engine', 'jade'
    app.use express.static(__dirname + '/public')
    app.use express.logger 'dev'
    app.use express.errorHandler
        dumpExceptions: true
        showStack: true

    # Index page
    app.get '/', (req, res) ->
        WebDAVAccount.first (err, account) ->
            if err
                next err
            else if not account?
                res.render 'index'
            else
                res.render 'index', account.toJSON()

    # Get credentials
    app.get '/token', (req, res) ->
        WebDAVAccount.first (err, account) ->
            if err
                res.send error: true, msg: err.toString(), 500
            else if not account?
                res.send error: true, msg: 'No webdav account generated', 404
            else
                res.send account.toJSON()

    # Generate credentials
    app.post '/token', (req, res) ->
        login = 'me'
        password = shortId.generate()
        data = login: login, password: password

        WebDAVAccount.first (err, account) ->
            if err
                res.send error: true, msg: err.toString(), 500
            else if not account?
                WebDAVAccount.create data, (err, account) ->
                    if err then res.send error: true, msg: err.toString(), 500
                    else res.send success: true, account: account.toJSON()
            else
                account.login = login
                account.password = password
                account.save (err) ->
                    if err then res.send error: true, msg: err.toString(), 500
                    else res.send success: true, account: account.toJSON()


    app.propfind '*', (req, res) ->
        if /^\/public/.test req.url
            req.url = req.url.replace '/public', '/public/webdav'
            daVServer.exec req, res
        else
            res.send error: true, msg: 'Path not found', 404

    app

