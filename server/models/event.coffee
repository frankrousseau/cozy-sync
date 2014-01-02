americano = require 'americano-cozy'

time = require 'time'
moment = require 'moment'
{VCalendar, VTodo, VAlarm, VEvent} = require '../lib/ical_helpers'

# EVENT
module.exports = Event = americano.getModel 'Event',
    id:          String
    start:       String
    end:         String
    place:       String
    description: String
    diff:        Number
    related:     type: String, default: null


Event.all = (cb) -> Event.request 'all', cb
Event::toIcal = (user, timezone) ->
    startDate = new time.Date @start
    endDate = new time.Date @end
    startDate.setTimezone timezone, false
    endDate.setTimezone timezone, false
    new VEvent startDate, endDate, @description, @place

Event.fromIcal = (vevent) ->
    event = new Event()
    description = vevent.fields["DESCRIPTION"]
    description = vevent.fields["SUMMARY"] unless description?
    event.description = description
    event.place = vevent.fields["LOCATION"]
    startDate = vevent.fields["DTSTART"]
    startDate = moment startDate, "YYYYMMDDTHHmm00"
    startDate = new time.Date new Date(startDate), 'UTC'
    endDate = vevent.fields["DTEND"]
    endDate = moment endDate, "YYYYMMDDTHHmm00"
    endDate = new time.Date new Date(endDate), 'UTC'
    event.start = startDate.toString().slice(0, 24)
    event.end = endDate.toString().slice(0, 24)
    event
