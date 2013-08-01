# Interface = require 'jsdav/lib/DAVACL/interfaces/iBackend'

module.exports = class PrincipalBackend

    principal = 
        uri:                 'principals/me'
        '{DAV:}displayname': 'cozy owner'

    getPrincipalsByPrefix: (prefixPath, callback) ->
        console.log "getPrincipalsByPrefix", prefixPath
        callback null, [principal]

    getPrincipalByPath: (path, callback) ->
        console.log "getPrincipalByPath", path
        callback null, principal

    updatePrincipal: (path, mutations, callback) ->
        callback null, false

    searchPrincipals: (prefixPath, searchProperties, callback) ->
        callback null, [principal.uri]

    getGroupMemberSet: (principal, callback) ->
        callback null, [principal]

    getGroupMemberShip: (principal, callback) ->
        callback null, [principal]

    setGroupMemberSet: (principal, members, callback) ->
        callback null, false
