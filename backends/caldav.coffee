"use strict";

Exc = require "jsDAV/lib/shared/exceptions"
async = require "async"
{ICalParser, VCalendar, VEvent, VTodo} = require "../lib/ical_helpers"

module.exports = class CozyCalDAVBackend

    constructor: (models) ->
        {@Event, @Alarm} = models

    getCalendarsForUser: (principalUri, callback) ->
        calendar =
            id: 'my-calendar'
            uri: 'my-calendar'
            principaluri: principalUri
            "{DAV:}displayname": 'Cozy Calendar'
        callback null, [calendar]

    createCalendar: (principalUri, url, properties, callback) ->
        callback null, null

    updateCalendar: (calendarId, mutations, callback) ->
        callback null, null

    deleteCalendar: (calendarId, callback) ->
        callback null, null

    _toICal: (obj) ->
        cal = new VCalendar('cozy', 'my-calendar')
        cal.add obj.toIcal() #todo : handle user & timezone
        cal.toString()

    getCalendarObjects: (calendarId, callback) ->
        objects = []
        async.parallel [
            (cb) => @Alarm.all (err, items) =>
                console.log 'alarm.all', err?.stack, items
                cb(err, items)
            (cb) => @Event.all (err, items) =>
                console.log 'event.all', err?.stack, items
                cb(err, items)
        ], (err, results) =>
            return callback err if err

            objects = results[0].concat(results[1])

            callback null, objects.map (obj) =>
                id:           obj.id
                uri:          obj.caldavuri or (obj.id + '.ics')
                calendardata: @_toICal(obj)
                lastmodified: null

    _findCalendarObject: (calendarId, objectUri, callback) ->

        require('eyes').inspect objectUri

        async.series [
            (cb) => @Alarm.byURI objectUri, (err, item) =>
                console.log 'alarm.byURI', err, item
                cb(err?.stack, item)
            (cb) => @Event.byURI objectUri, (err, item) =>
                console.log 'event.byURI', err, item
                cb(err?.stack, item)
        ], (err, results) =>
            console.log "ASYNCRES", results
            callback err, (results[0]?[0] or results[1]?[0])

    _parseSingleObjICal: (calendarData, callback) ->
        new ICalParser().parseString calendarData, (err, calendar) =>
            return callback err if err
            # TODO BE SMARTER

            timezone = calendar.subComponents[0]
            daylightl = calendar.subComponents[0]
            callback null, calendar.subComponents[1]


    getCalendarObject: (calendarId, objectUri, callback) ->

        console.log "GETCALENDAROBJECT", calendarId, objectUri

        @_findCalendarObject calendarId, objectUri, (err, obj) =>
            return callback err if err
            return callback null, null unless obj

            console.log "WE ARE HERE"

            return callback null,
                id:           obj.id
                uri:          obj.caldavuri or (obj.id + '.ics')
                calendardata: @_toICal(obj)
                lastmodified: new Date().getTime()


    createCalendarObject: (calendarId, objectUri, calendarData, callback) =>
        @_parseSingleObjICal calendarData, (err, obj) =>
            return callback err if err

            if obj.name is 'VEVENT'
                event = @Event.fromIcal obj
                event.caldavuri = objectUri
                @Event.create event, (err, event) ->
                    callback err, null

            else if obj.name is 'VTODO'
                console.log "ALARM"
                alarm = @Alarm.fromIcal obj
                alarm.caldavuri = objectUri
                @Alarm.create alarm, (err, alarm) ->
                    callback err, null

            else
                callback Exc.notImplementedYet()


    updateCalendarObject: (calendarId, objectUri, calendarData, callback) ->
        @_findCalendarObject calendarId, objectUri, (err, oldObj) ->
            return callback err if err

            @_parseSingleObjICal calendarData, (err, newObj) =>
                return callback err if err

                if newObj.name is 'VEVENT' and oldObj instanceof Event
                    event = @Event.fromIcal newObj
                    oldObj.updateAttributes event, (err, event) ->
                        callback err, null

                else if newObj.name is 'VTODO' and oldObj instanceof Alarm
                    console.log "ALARM"
                    alarm = @Alarm.fromIcal newObj
                    oldObj.updateAttributes alarm, (err, alarm) ->
                        callback err, null

                else
                    callback Exc.notImplementedYet()

    deleteCalendarObject: (calendarId, objectUri, callback) ->
        @_findCalendarObject calendarId, objectUri, (err, obj) ->
            return callback err if err
            obj.destroy callback

    calendarQuery: (calendarId, filters, callback) ->
        callback Exc.notImplementedYet()
