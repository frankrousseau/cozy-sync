americano = require 'americano-cozy'

time = require 'time'
moment = require 'moment'
{VCalendar, VTodo, VAlarm, VEvent} = require '../lib/ical_helpers'


# ALARM
module.exports = Alarm = americano.getModel 'Alarm',
    id:          String
    trigg:       String
    description: String
    action:      type: String, default: 'DISPLAY'
    related:     type: String, default: null

Alarm.all = (cb) -> Alarm.request 'all', cb

Alarm::toIcal = (user, timezone) ->
    date = new time.Date @trigg
    date.setTimezone timezone, false
    vtodo = new VTodo date, user, @description
    vtodo.addAlarm date
    vtodo

Alarm.fromIcal = (valarm) ->
    alarm = new Alarm()
    alarm.description = valarm.fields["SUMMARY"]
    date = valarm.fields["DSTAMP"]
    date = moment(date, "YYYYMMDDTHHmm00")
    triggerDate = new time.Date new Date(date), 'UTC'
    alarm.trigg = triggerDate.toString().slice(0, 24)
    alarm



