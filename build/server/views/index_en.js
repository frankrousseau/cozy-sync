var jade = require('jade/runtime');

module.exports = function template(locals) {
var buf = [];
var jade_mixins = {};
var locals_ = (locals || {}),login = locals_.login,domain = locals_.domain,calendars = locals_.calendars,password = locals_.password;
buf.push("<!DOCTYPE html><html lang=\"en\"><head><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"><title>Cozy - Sync</title><link rel=\"stylesheet\" href=\"stylesheets/app.css\"><link rel=\"icon\" type=\"image/x-icon\" href=\"favicon.ico\"><link rel=\"icon\" type=\"image/png\" href=\"favicon-96x96.png\" sizes=\"96x96\"><link rel=\"icon\" type=\"image/png\" href=\"favicon-16x16.png\" sizes=\"16x16\"><link rel=\"icon\" type=\"image/png\" href=\"favicon-32x32.png\" sizes=\"32x32\"></head><body><div id=\"content\"><h1>WebDAV: CalDAV and CardDAV</h1><p>WebDAV is a standard protocol that allows any device (that suppports\nit) to get synchronized with the Contact, Calendar and Files\ninformations from your Cozy. So, if you want that your smartphone to\nbe kept up to date with your Cozy, you will find in the following,\nthe instructions to set this synchronization.</p><h1>Server Credentials</h1><p>Before going further, you need to set specific credentials for your\nCalDAV server (your calendar phone application should not be able to\naccess to your whole Cozy). Here are the credentials required for\nyour client to get synchronized</p><div class=\"url credentials\"><p>login:&nbsp;<span id=\"login-span\">" + (jade.escape((jade.interp = login) == null ? '' : jade.interp)) + "</span></p><p>password:&nbsp;<span id=\"password-span\"></span><button id=\"show-password\">Show</button><button id=\"hide-password\">Hide</button></p><button id=\"generate-btn\">reset password</button></div>");
var dDomain = (domain == '') ? 'your.cozy.url' : domain
buf.push("<h1>CalDAV configuration (Calendar)</h1><p>Your client will ask for an url on which to connect, here are the\nrequired ones, depending on your phone or software.</p><h2 data-device=\"ios\" class=\"tab caldav selected\">iOS</h2><h2 data-device=\"android\" class=\"tab caldav\">Android</h2><h2 data-device=\"thunderbird\" class=\"tab caldav\">Thunderbird (Lightning)</h2><div data-device=\"ios\" class=\"caldavconf\"><p>In the \"Server\" field, type:</p><p id=\"iosuri\" class=\"url\">" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync/principals/me</p></div><div data-device=\"android\" class=\"caldavconf\"><p>To sync your android phone with CalDAV, you have\nto install a dedicated app. The required url depend of that app. But\nyou can try that one by default:</p><p class=\"url\">https://" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync/principals/me/</p></div><div data-device=\"thunderbird\" class=\"caldavconf\"><p>Select a calendar:&nbsp;<select id=\"calendar\"><option id=\"placeholder\" value=\"\">-              </option>");
// iterate calendars
;(function(){
  var $$obj = calendars;
  if ('number' == typeof $$obj.length) {

    for (var $index = 0, $$l = $$obj.length; $index < $$l; $index++) {
      var c = $$obj[$index];

buf.push("<option" + (jade.attr("value", encodeURIComponent(c), true, true)) + ">" + (jade.escape(null == (jade.interp = c) ? "" : jade.interp)) + "</option>");
    }

  } else {
    var $$l = 0;
    for (var $index in $$obj) {
      $$l++;      var c = $$obj[$index];

buf.push("<option" + (jade.attr("value", encodeURIComponent(c), true, true)) + ">" + (jade.escape(null == (jade.interp = c) ? "" : jade.interp)) + "</option>");
    }

  }
}).call(this);

buf.push("</select></p><p>Then use the following url:</p><p id=\"thunderbirduri\" class=\"url\"></p></div><h1>CardDAV configuration (Contacts)</h1><p>Your client will ask for an url on which to connect, here are the\nrequired ones, depending on your phone or software.</p><h2 data-device=\"ios\" class=\"tab carddav selected\">iOS</h2><h2 data-device=\"android\" class=\"tab carddav\">Android</h2><h2 data-device=\"thunderbird\" class=\"tab carddav\">Thunderbird (SOGo)</h2><div data-device=\"ios\" class=\"carddavconf\"><p>In the \"Server\" field, type:</p><p class=\"url\">" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync</p></div><div data-device=\"android\" class=\"carddavconf\"><p>To sync your android phone with CardDAV, you have\nto install a dedicated app. The required url depend of your app. But\nyou can try that one by default:</p><p class=\"url\">https://" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync/principals/me/</p></div><div data-device=\"thunderbird\" class=\"carddavconf\"><p>To sync contacts with thunderbird, you have to install the SOGo\naddon. Then use the following url:</p><p class=\"url\">https://" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync/addressbooks/me/all-contacts/</p></div><h1>WebDAV configuration (Files)</h1><p>Cozy doesn't support file synchronization through WebDAV. We will\nprovide soon another way to do it. It will support offline working\ntoo.</p><h1>Troubleshooting</h1><p>If you use another client and are experimenting\nproblems, please let us know about it&nbsp;<a target=\"_blank\" href=\"https://github.com/mycozycloud/cozy-webdav/issues\">on Github!</a></p></div><script>window.password = \"" + (jade.escape((jade.interp = password) == null ? '' : jade.interp)) + "\";</script><script src=\"javascripts/vendor.js\"></script><script src=\"javascripts/app.js\" onload=\"require('initialize');\"></script></body></html>");;return buf.join("");
}