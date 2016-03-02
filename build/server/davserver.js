// Generated by CoffeeScript 1.9.3
var Event, User, caldavBackend, carddavBackend, cozy_Auth_Backend, cozy_CalBackend, cozy_CardBackend, cozy_PrincipalBackend, jsCalDAV_CalendarRoot, jsCardDAV_AddressBookRoot, jsDAV, jsDAVACL_PrincipalCollection, nodeCalDAV, nodeCardDAV, nodePrincipalCollection, principalBackend;

jsDAV = require("cozy-jsdav-fork");

jsDAV.debugMode = !!process.env.DEBUG;

cozy_Auth_Backend = require('./backends/auth');

jsDAVACL_PrincipalCollection = require("cozy-jsdav-fork/lib/DAVACL/principalCollection");

cozy_PrincipalBackend = require('./backends/principal');

principalBackend = new cozy_PrincipalBackend;

nodePrincipalCollection = jsDAVACL_PrincipalCollection["new"](principalBackend);

jsCardDAV_AddressBookRoot = require("cozy-jsdav-fork/lib/CardDAV/addressBookRoot");

cozy_CardBackend = require('./backends/carddav');

carddavBackend = new cozy_CardBackend(require('./models/contact'));

nodeCardDAV = jsCardDAV_AddressBookRoot["new"](principalBackend, carddavBackend);

Event = require('./models/event');

User = require('./models/user');

jsCalDAV_CalendarRoot = require("cozy-jsdav-fork/lib/CalDAV/calendarRoot");

cozy_CalBackend = require('./backends/caldav');

caldavBackend = new cozy_CalBackend(Event, User);

nodeCalDAV = jsCalDAV_CalendarRoot["new"](principalBackend, caldavBackend);

module.exports = jsDAV.mount({
  server: true,
  standalone: false,
  realm: 'jsDAV',
  mount: '/public/sync/',
  authBackend: cozy_Auth_Backend["new"](),
  plugins: [require("cozy-jsdav-fork/lib/DAV/plugins/auth"), require("cozy-jsdav-fork/lib/CardDAV/plugin"), require("cozy-jsdav-fork/lib/CalDAV/plugin"), require("cozy-jsdav-fork/lib/DAVACL/plugin")],
  node: [nodePrincipalCollection, nodeCardDAV, nodeCalDAV]
});
