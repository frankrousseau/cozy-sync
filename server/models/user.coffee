americano = require 'americano-cozy'

module.exports = User = americano.getModel 'User',
    timezone: type: String, default: "Europe/Paris"

User.getTimezone = (callback) ->
    User.all (err, users) ->
        return callback err if err
        callback null, users?[0]?.timezone or "Europe/Paris"

User.updateUser = (callback) ->
    User.getTimezone (err, timezone) ->
        if err
            console.log err
            User.timezone = 'Europe/Paris'
        else
            User.timezone = timezone or "Europe/Paris"
        callback?()
