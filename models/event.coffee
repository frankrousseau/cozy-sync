db = require './db'

# EVENT
module.exports = Event = db.define 'Event',
    id:          String
    caldavuri:   String
    start:       String
    end:         String
    place:       String
    description: String
    diff:        Number
    related:     type: String, default: null

# Add Ical utilities to Event model
require('cozy-ical/lib/event')(Event)


byURI = (doc) -> emit (doc.caldavuri or doc._id + '.ics'), doc
Event.defineRequest 'byURI', byURI, ->
    console.log 'Event "byURI" request created'
Event.all = (cb) -> Event.request 'byURI', cb
Event.byURI = (uri, cb) ->
    # See Alarm
    req = Event.request 'byURI', null, cb
    req.body = JSON.stringify key: uri
    req.setHeader 'content-type', 'application/json'