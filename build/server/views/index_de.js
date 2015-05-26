var jade = require('jade/runtime');

module.exports = function template(locals) {
var buf = [];
var jade_mixins = {};
var locals_ = (locals || {}),login = locals_.login,domain = locals_.domain,calendars = locals_.calendars,password = locals_.password;
buf.push("<!DOCTYPE html><html lang=\"de\"><head><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"><title>Cozy - Sync</title><link rel=\"stylesheet\" href=\"/fonts/fonts.css\"><link rel=\"stylesheet\" href=\"stylesheets/app.css\"><link rel=\"icon\" type=\"image/x-icon\" href=\"favicon.ico\"><link rel=\"icon\" type=\"image/png\" href=\"favicon-96x96.png\" sizes=\"96x96\"><link rel=\"icon\" type=\"image/png\" href=\"favicon-16x16.png\" sizes=\"16x16\"><link rel=\"icon\" type=\"image/png\" href=\"favicon-32x32.png\" sizes=\"32x32\"></head><body><div id=\"content\"><div class=\"content-block\"><h1>WebDAV: CalDAV und CardDAV</h1><p>WebDAV ist ein Standard Protokol das jedem Gerät (das es unterstützt)\nSynchronisation mit den Kontakt, Kalender und Datei Informationen\ndes Cozy ermöglicht. So, wenn Sie möchten dass Ihr Smartphone\naktuell/gleich mit Ihrem Cozy gehalten wird, finden Sie folgend\nAnweisungen zur Einrichtung der Synchronisation.</p></div><div class=\"content-block\"><h1>Server Anmeldeinformationen</h1><p>Bevor Sie weiter machen, müssen Sie bestimmte Anmeldeinformationen für Ihren\nCalDAV Server festlegen (Ihre Smartphone Kalender Applikation sollte nicht\nkompletten Zugriff auf Ihr Cozy bekommen). Hier sind die erforderlichen Anmelde-\nInformationen für Ihren Client um synchronisiert zu werden.</p><div class=\"url credentials\"><p>Benutzername :&nbsp;<span id=\"login-span\">" + (jade.escape((jade.interp = login) == null ? '' : jade.interp)) + "</span></p><p>Passwort :&nbsp;<span id=\"password-span\"></span><button id=\"show-password\">Anzeigen</button><button id=\"hide-password\">Verbergen</button></p><button id=\"generate-btn\">Passwort rücksetzen</button></div>");
var dDomain = (domain == '') ? 'ihre.cozy.url' : domain
buf.push("</div><div class=\"content-block\"><h1>CalDAV Konfiguration (Kalendar)</h1><p>Ihr Client wird nach einer URL zur Verbindung fragen, hier sind die\nbenötigten, abhängig von Ihrem Smartphone oder der Software.</p><div class=\"content-tab\"><div class=\"menu-tab\"><h2 data-device=\"ios\" class=\"tab caldav selected\">iOS</h2><h2 data-device=\"android\" class=\"tab caldav\">Android</h2><h2 data-device=\"thunderbird\" class=\"tab caldav\">Thunderbird (Lightning)</h2></div><div data-device=\"ios\" class=\"caldavconf\"><p>In das Feld \"Server\", eintragen:</p><p id=\"iosuri\" class=\"url\">" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync/principals/me</p></div><div data-device=\"android\" class=\"caldavconf\"><p>Um Ihr Android Smartphone mit CalDAV zu synchronisieren, müssen Sie\neine entsprechende APP installieren. Die benötigte URL hängt von der App ab.\nAber Sie können es mit dieser Standard URL versuchen:</p><p class=\"url\">https://" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync/principals/me/</p></div><div data-device=\"thunderbird\" class=\"caldavconf\"><p>Wälen Sie einen Kalendar:&nbsp;<select id=\"calendar\"><option id=\"placeholder\" value=\"\">-</option>");
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

buf.push("</select></p><p>Dann benutzen Sie die folgende URL:</p><p id=\"thunderbirduri\" class=\"url\"></p></div></div></div><div class=\"content-block\"><h1>CardDAV Konfiguration (Kontakte)</h1><p>Ihr Client wird nach einer URL zur Verbindung fragen, hier sind die\nbenötigten, abhängig von Ihrem Smartphone oder der Software.</p><div class=\"content-tab\"><div class=\"menu-tab\"><h2 data-device=\"ios\" class=\"tab carddav selected\">iOS</h2><h2 data-device=\"android\" class=\"tab carddav\">Android</h2><h2 data-device=\"thunderbird\" class=\"tab carddav\">Thunderbird (SOGo)</h2></div><div data-device=\"ios\" class=\"carddavconf\"><p>In das Feld \"Server\", eintragen:</p><p class=\"url\">" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync</p></div><div data-device=\"android\" class=\"carddavconf\"><p>Um Ihr Android Smartphone mit CalDAV zu synchronisieren, müssen Sie\neine entsprechende APP installieren. Die benötigte URL hängt von der App ab.\nAber Sie können es mit dieser Standard URL versuchen:</p><p class=\"url\">https://" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync/principals/me/</p></div><div data-device=\"thunderbird\" class=\"carddavconf\"><p>Um Kontakte mit Thunderbird zu synchronisieren, müssen Sie das SOGo addon\ninstallieren. Dann folgende URL benutzen:</p><p class=\"url\">https://" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync/addressbooks/me/all-contacts/</p></div></div></div><div class=\"content-block\"><h1>WebDAV Konfiguration (Dateien)</h1><p>Cozy unterstützt die Datei_Synchronisation via WebDAV nicht. Wir werden bald einen\nanderen Weg dafür bereitstellen. Es wird auch \"Offline\" arbeiten unterstützen.</p></div><div class=\"content-block\"><h1>Problemlösung</h1><p>Wenn Sie einen anderen Client nutzen und Probleme auftreten,\nbitte informieren Sie uns darüber it&nbsp;<a target=\"_blank\" href=\"https://github.com/mycozycloud/cozy-webdav/issues\">on Github!</a></p></div></div><script>window.password = \"" + (jade.escape((jade.interp = password) == null ? '' : jade.interp)) + "\";</script><script src=\"javascripts/vendor.js\"></script><script src=\"javascripts/app.js\" onload=\"require('initialize');\"></script></body></html>");;return buf.join("");
}