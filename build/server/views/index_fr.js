var jade = require('jade/runtime');

module.exports = function template(locals) {
var buf = [];
var jade_mixins = {};
var locals_ = (locals || {}),login = locals_.login,domain = locals_.domain,calendars = locals_.calendars,password = locals_.password;
buf.push("<!DOCTYPE html><html lang=\"fr\"><head><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"><title>Cozy - Sync</title><link rel=\"stylesheet\" href=\"stylesheets/app.css\"><link rel=\"icon\" type=\"image/x-icon\" href=\"favicon.ico\"><link rel=\"icon\" type=\"image/png\" href=\"favicon-96x96.png\" sizes=\"96x96\"><link rel=\"icon\" type=\"image/png\" href=\"favicon-16x16.png\" sizes=\"16x16\"><link rel=\"icon\" type=\"image/png\" href=\"favicon-32x32.png\" sizes=\"32x32\"></head><body><div id=\"content\"><h1>WebDAV: CalDAV et CardDAV</h1><p>WebDav est un protocole standard qui permet à n'importe quel périphérique\n(qui le supporte) de synchroniser les contacts, l'agenda et les fichiers\navec votre Cozy. Si vous voulez que les contacts et l'agenda de\nvotre smartphone soient synchronisés avec votre Cozy (et vice-versa !),\nvous trouverez les étapes de configuration sur cette page.</p><h1>Identifiants du serveur</h1><p>Avant d'aller plus loin, vous devez générer des identifiants spécifiques\npour l'application afin de ne pas laisser vos données en libre accès.\nCes identifiants seront utilisés par vos périphériques à synchroniser\npour se connecter à votre Cozy en votre nom.</p><div class=\"url credentials\"><p>Nom d'utilisateur :&nbsp;<span id=\"login-span\">" + (jade.escape((jade.interp = login) == null ? '' : jade.interp)) + "</span></p><p>Mot de passe :&nbsp;<span id=\"password-span\"></span><button id=\"show-password\">Montrer</button><button id=\"hide-password\">Cacher</button></p><button id=\"generate-btn\">Réinitialiser le mot de passe</button></div>");
var dDomain = (domain == '') ? 'votre.url.cozy' : domain
buf.push("<h1>Configuration de CalDav (Agenda)</h1><p>Lors du processus de configuration, votre smartphone va vous demander de saisir une URL\nsur laquelle se connecter ; voici les différentes adresses disponibles en fonction\nde votre téléphone ou application.</p><h2 data-device=\"ios\" class=\"tab caldav selected\">iOS</h2><h2 data-device=\"android\" class=\"tab caldav\">Android</h2><h2 data-device=\"thunderbird\" class=\"tab caldav\">Thunderbird (Lightning)</h2><div data-device=\"ios\" class=\"caldavconf\"><p>Dans le champ \"Serveur\", écrivez :</p><p id=\"iosuri\" class=\"url\">" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync/principals/me</p></div><div data-device=\"android\" class=\"caldavconf\"><p>Pour synchroniser l'agenda de votre téléphone Android, vous\ndevez installer une application dédiée (faites une recherche sur\nGoogle Play avec le mot-clé \"caldav\"). L'URL à utiliser dépend de\ncette application, mais vous pouvez essayer la suivante par défaut :</p><p class=\"url\">https://" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync/principals/me/</p></div><div data-device=\"thunderbird\" class=\"caldavconf\"><p>Sélectionnez un agenda :&nbsp;<select id=\"calendar\"><option id=\"placeholder\" value=\"\">-              </option>");
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

buf.push("</select></p><p>Puis utilisez l'URL suivante :</p><p id=\"thunderbirduri\" class=\"url\"></p></div><h1>Configuration de CardDav (Contacts)</h1><p>Lors du processus de configuration, votre smartphone va vous demander de saisir une URL\nsur laquelle se connecter, voici les différentes adresses en fonction\nde votre téléphone ou application.</p><h2 data-device=\"ios\" class=\"tab carddav selected\">iOS</h2><h2 data-device=\"android\" class=\"tab carddav\">Android</h2><div data-device=\"ios\" class=\"carddavconf\"><p>Dans le champ \"Serveur\", écrivez :</p><p class=\"url\">" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync</p></div><div data-device=\"android\" class=\"carddavconf\"><p>Pour synchroniser les contacts de votre téléphone Android, vous\ndevez installer une application dédiée (faites une recherche sur\nGoogle Play avec le mot-clé \"carddav\"). L'URL à utiliser dépend de\ncette application, mais vous pouvez essayer la suivante par défaut :</p><p class=\"url\">https://" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync/principals/me/</p></div><h1>Configuration de WebDav (Fichiers)</h1><p>Cozy ne supporte pas la synchronisation de fichiers à travers WebDav.\nNous allons fournir une autre façon de synchroniser vos fichiers\navec une application Cozy et des logiciels pour les différents systèmes\nd'exploitation et téléphones.</p><h1>Dépannage</h1><p>Si vous rencontrez des problèmes, faites-le nous savoir&nbsp;<a target=\"_blank\" href=\"https://github.com/mycozycloud/cozy-webdav/issues\">sur Github !</a></p></div><script>window.password = \"" + (jade.escape((jade.interp = password) == null ? '' : jade.interp)) + "\";</script><script src=\"javascripts/vendor.js\"></script><script src=\"javascripts/app.js\" onload=\"require('initialize');\"></script></body></html>");;return buf.join("");
}