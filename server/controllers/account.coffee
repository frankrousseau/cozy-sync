fs = require 'fs'
path = require 'path'
async = require 'async'
WebDAVAccount = require '../models/webdavaccount'
CozyInstance = require '../models/cozyinstance'
Event = require '../models/event'
log = require('printit')
    prefix: 'account:controller'

# Get the template name for given locale, fallbacks to english template
getTemplateName = (locale) ->
    # If run from build/, templates are compiled to JS
    # otherwise, they are in jade
    filePath = path.resolve __dirname, '../views/index_en.js'
    runFromBuild = fs.existsSync filePath
    extension = if runFromBuild then 'js' else 'jade'

    fileName = "index_#{locale}.#{extension}"
    filePath = path.resolve __dirname, "../views/#{fileName}"
    fileName = "index_en.#{extension}" unless fs.existsSync(filePath)
    return fileName

module.exports =
    index: (req, res) ->
        async.parallel {
            davAccount: (done) -> WebDAVAccount.first done
            calendarTags: (done) -> Event.calendars done
            instance: (done) -> CozyInstance.first done
        }, (err, results) ->

            log.error err if err?

            {davAccount, calendarTags, instance} = results
            calendarNames = calendarTags.map (calendar) -> calendar.name

            locale = instance?.locale or 'en'
            domain = instance?.domain or ''

            data =
                login: davAccount?.login
                password: davAccount?.token
                domain: domain
                calendars: calendarNames

            fileName = getTemplateName locale

            res.render fileName, data

    createCredentials: (req, res) ->
        WebDAVAccount.createAccount (err, account) ->
            if err?
                res.send 500, error: err.toString()
            else
                res.send 201, success: true, account: account.toJSON()
