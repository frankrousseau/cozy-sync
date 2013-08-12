db = require './db'

# EVENT
module.exports = User = db.define 'User',
    timezone: type: String, default: "Europe/Paris"

# Get the user's timezone
User.getTimezone = (callback) ->
    User.all (err, users) ->
        return callback err if err
        callback null, users?[0]?.timezone or "Europe/Paris"