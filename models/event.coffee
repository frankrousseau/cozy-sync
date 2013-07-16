db = require './db'

Alarm = define 'Alarm', ->

    property 'action', String, default: 'DISPLAY'
    property 'trigg', String
    property 'description', String

    property 'related', String, default: null