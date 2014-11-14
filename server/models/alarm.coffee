americano = require 'americano-cozy'

# ALARM
module.exports = Alarm = americano.getModel 'Alarm',
    id:          String
    caldavuri:   String
    trigg:       String
    description: String
    timezone:    String
    action:      type: String, default: 'DISPLAY'
    related:     type: String, default: null
    tags : type : (x) -> x

# Add Ical utilities to Alarm model
require('cozy-ical').decorateAlarm Alarm

Alarm.all = (cb) -> Alarm.request 'byURI', cb

Alarm.byCalendar = (calendarId, callback) ->
    Alarm.request 'byCalendar', key: calendarId, callback

Alarm.byURI = (uri, cb) ->
    # this fail in strange way if we let request handle JSON
    # bug tracked down to Node's EventEmitter in request :
    # the array is lost somehow
    # unable to reproduce outside of the app
    # may be some module is messing with EventEmitter
    #
    # console.log response.body  ===> [{object}]
    # self.emit 'complete', response, response.body
    # self.on 'complete', -> console arguments
    #     ===>  {body: [{object}]}, {object} <---- no [ ]
    req = Alarm.request 'byURI', null, cb
    req.body = JSON.stringify key: uri
    req.setHeader 'content-type', 'application/json'

Alarm.tags = (callback) ->
    Alarm.rawRequest "tags", group: true, (err, results) ->
        return callback err if err
        out = calendar: [], tag: []
        for result in results
            [type, tag] = result.key
            out[type].push tag
        callback null, out
