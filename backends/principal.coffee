# Interface = require 'jsdav/lib/DAVACL/interfaces/iBackend'

module.exports = class PrincipalBackend

	principal = 
		uri: 'my'
		'{DAV:}displayname': 'cozy owner'

	getPrincipalsByPrefix: (prefixPath, callback) ->
		callback [principal]

    getPrincipalByPath: (path, callback) ->
    	callback [principal]

    updatePrincipal: (path, mutations, callback) ->
    	callback false

    searchPrincipals: (prefixPath, searchProperties, callback) ->
    	callback [principal.uri]

    getGroupMemberSet: (principal, callback) ->
    	callback [principal]

    getGroupMembership: (principal, callback) ->
    	callback [principal]

    setGroupMemberSet: (principal, members, callback) ->
    	callback false
