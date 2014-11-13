americano = require 'americano-cozy'

time = require 'time'
moment = require 'moment'
{VCalendar, VTodo, VAlarm, VEvent} = require '../lib/ical_helpers'

# EVENT
module.exports = Event = americano.getModel 'Event',
    id: type:String, default: null
    caldavuri: String
    start: String
    end: String
    place: type: String, default: ''
    details: type: String, default: ''
    description: type: String, default: ''
    rrule: String
    attendees   : type : [Object]
    related: type: String, default: null
    timezone    : type : String
    alarms      : type : [Object]

# Add Ical utilities to Event model
require('cozy-ical').decorateEvent Event

# 'start' and 'end' use those format,
# According to allDay or rrules.
Event.dateFormat = 'YYYY-MM-DD'
Event.ambiguousDTFormat = 'YYYY-MM-DD[T]HH:mm:00'
Event.utcDTFormat = 'YYYY-MM-DD[T]HH:mm:00.000Z'

# Handle only unique units strings.
Event.alarmTriggRegex = /(\+?|-)PT?(\d+)(W|D|H|M|S)/

Event.all = (cb) -> Event.request 'byURI', cb
Event.byURI = (uri, cb) ->
    # See Alarm
    req = Event.request 'byURI', null, cb
    req.body = JSON.stringify key: uri
    req.setHeader 'content-type', 'application/json'
