fs = require 'fs'
path = require 'path'
WebDAVAccount = require '../models/webdavaccount'
CozyInstance = require '../models/cozyinstance'
Event = require '../models/event'

davAccount = null
WebDAVAccount.first (err, account) ->
    if account? then davAccount = account
    else davAccount = null

cozyInstance = null
CozyInstance.first (err, instance) ->
    if instance? then cozyInstance = instance
    else cozyInstance = null

module.exports =
    index: (req, res) ->
        locale = cozyInstance?.locale or 'en'

        filename = "index_#{locale}"
        filePath = path.resolve __dirname, "../views/#{filename}.jade"
        try
            stats = fs.lstatSync filePath
        catch e
            filename = "index_en"

        if cozyInstance?.domain?
            domain = cozyInstance.domain
        else
            domain = ''
        
        Event.calendars (err, calendars) ->
            data =
                login: davAccount?.login
                password: davAccount?.token
                domain: domain
                calendars: calendars

            res.render filename, data

    getCredentials: (req, res) ->
        if davAccount?
            res.send davAccount.toJSON()
        else
            res.send error: true, msg: 'No webdav account generated', 404

    createCredentials: (req, res) ->
        WebDAVAccount.createAccount (err, account) ->
            if err?
                res.send 500, error: err.toString()
            else
                res.send 201, success: true, account: account.toJSON()
