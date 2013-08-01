"use strict";

Exc = require "jsDAV/lib/shared/exceptions"
async = require "async"
{VCalendar} = require "../lib/ical_helpers"

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
            (cb) => @Alarm.request 'byId', (err, items) =>
                console.log 'alarm.all', err, items
                cb(err?.stack, items)
            (cb) => @Event.request 'byId', (err, items) =>
                console.log 'event.all', err, items
                cb(err?.stack, items)
        ], (err, results) =>
            return callback err if err

            objects = results[0].concat results[1]

            objects = objects.map (obj) =>
                id:           obj.id
                uri:          obj.id
                calendardata: @_toICal(obj)
                lastmodified: null

            callback null, objects

    _findCalendarObject: (calendarId, objectUri, callback) ->
        async.parallel [
            (cb) => @Alarm.find objectUri, (err, items) =>
                console.log 'alarm.all', err?.stack, items
                cb(err?.stack, items)
            (cb) => @Event.find objectUri, (err, items) =>
                console.log 'alarm.all', err?.stack, items
                cb(err?.stack, items)
        ], (err, results) =>
            callback err, (results[0] or results[1])

    getCalendarObject: (calendarId, objectUri, callback) ->
        @_findCalendarObject calendarId, objectUri, (err, obj) =>
            return callback err if err
            return callback null, null unless obj

            return callback null,
                id:           obj.id
                uri:          obj.id
                calendardata: @_toICal(obj)
                lastmodified: new Date().getTime()


    createCalendarObject: (calendarId, objectUri, calendarData, callback) ->
        callback Exc.notImplementedYet()


    updateCalendarObject: (calendarId, objectUri, calendarData, callback) ->
        @_findCalendarObject calendarId, objectUri, (err, obj) ->
            return callback err if err
            obj.updateAttributesIcal calendarData

    deleteCalendarObject: (calendarId, objectUri, callback) ->
        @_findCalendarObject calendarId, objectUri, (err, obj) ->
            return callback err if err
            obj.destroy callback

    calendarQuery: (calendarId, filters, callback) ->
        callback Exc.notImplementedYet()
