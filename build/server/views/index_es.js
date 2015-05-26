var jade = require('jade/runtime');

module.exports = function template(locals) {
var buf = [];
var jade_mixins = {};
var locals_ = (locals || {}),login = locals_.login,domain = locals_.domain,dominio = locals_.dominio,calendars = locals_.calendars,password = locals_.password;
buf.push("<!DOCTYPE html><html lang=\"es\"><head><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"><title>Cozy - Sincronización</title><link rel=\"stylesheet\" href=\"stylesheets/app.css\"><link rel=\"icon\" type=\"image/x-icon\" href=\"favicon.ico\"><link rel=\"icon\" type=\"image/png\" href=\"favicon-96x96.png\" sizes=\"96x96\"><link rel=\"icon\" type=\"image/png\" href=\"favicon-16x16.png\" sizes=\"16x16\"><link rel=\"icon\" type=\"image/png\" href=\"favicon-32x32.png\" sizes=\"32x32\"></head><body><div id=\"content\"><h1>WebDAV: CalDAV y CardDAV</h1><p>WebDav es un protocolo standard que permite a cualquier periférico (que lo soporta)\nsincronizar los contactos, la agenda y los archivos con Cozy.\nSi usted desea que los contactos y la agenda de su teléfono\nse sincronicen con su Cozy (¡y vice-versa!), encontrará en esta página\nlas etapas que debe seguir para la configuración.</p><h1>Identificadores del servidor</h1><p>Antes de continuar, usted debe generar identificadores específicos\npara la aplicación con el fin de no dejar sus datos en libre acceso.\nLos periféricos que se han de sincronizar utilizarán esos identificadores\npara conectarse a su Cozy en su nombre.</p><div class=\"url credentials\"><p>Nombre del usuario:&nbsp;<span id=\"login-span\">" + (jade.escape((jade.interp = login) == null ? '' : jade.interp)) + "</span></p><p>contraseña:&nbsp;<span id=\"password-span\"></span><button id=\"show-password\">Mostrar</button><button id=\"hide-password\">Ocultar</button></p><button id=\"generate-btn\">reinicializar contraseña</button></div>");
var dDomain = (domain == '') ? 'your.cozy.url' : dominio
buf.push("<h1>Configuración de CalDav (Agenda)</h1><p>Durante el proceso de configuración su periférico va a pedirle una url para conectarse, he aquí<algunas>direcciones disponibles en función de su periférico o aplicación :</algunas></p><h2 data-device=\"ios\" class=\"tab caldav selected\">iOS</h2><h2 data-device=\"android\" class=\"tab caldav\">Android</h2><h2 data-device=\"thunderbird\" class=\"tab caldav\">Thunderbird (Lightning)</h2><div data-device=\"ios\" class=\"caldavconf\"><p>En la casilla \"Servidor\", escribir:</p><p id=\"iosuri\" class=\"url\">" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync/principals/me</p></div><div data-device=\"android\" class=\"caldavconf\"><p>Para sincronizar su periférico Android con CalDAV, usted tiene\nque instalar una aplicación dedicada. Pero\nen su defecto, ensaye con esta url:</p><p class=\"url\">https://" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync/principals/me/</p></div><div data-device=\"thunderbird\" class=\"caldavconf\"><p>Seleccione una agenda :&nbsp;<select id=\"calendar\"><option id=\"placeholder\" value=\"\">-</option>");
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

buf.push("</select></p><p>Y utilice la URL siguiente :</p><p id=\"thunderbirduri\" class=\"url\"></p></div><h1>Configuración de CardDav (Contacts)</h1><p>Durante el proceso de configuración su periférico va a pedirle una url para conectarse, he aquí<algunas>direcciones disponibles en función de su periférico o aplicación :</algunas></p><h2 data-device=\"ios\" class=\"tab carddav selected\">iOS</h2><h2 data-device=\"android\" class=\"tab carddav\">Android</h2><h2 data-device=\"android\" class=\"tab carddav\">Android</h2><div data-device=\"ios\" class=\"carddavconf\"><p>En la casilla \"Servidor\", escribir:</p><p class=\"url\">" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync</p></div><div data-device=\"android\" class=\"carddavconf\"><p>Para sincronizar los contactos de su periférico Android, usted tiene que\ninstalar una aplicación dedicada. La url que se requiere depende de su aplicación. Pero en su defecto, puede ensayar con ésta:\nen su defecto, ensaye con esta url:</p><p class=\"url\">https://" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync/principals/me/</p></div><div data-device=\"thunderbird\" class=\"carddavconf\"><p>Para sincronizar los contactos con thunderbird, usted tiene que instalar\nla extensión SOGo. Utilizar la url siguiente:</p><p class=\"url\">https://" + (jade.escape((jade.interp = dDomain) == null ? '' : jade.interp)) + "/public/sync/addressbooks/me/all-contacts/</p></div><h1>Configuración de WebDav (Archivos)</h1><p>Cozy no acepta la sincronización de archivos por medio de WebDav.<Proximamente>facilitaremos otra manera de hacerlo.</Proximamente>Aceptará trabajar off-line también.</p><h1>Solución de problemas</h1><p>Si usted utiliza otro cliente y encuentra\nproblemas, le rogamos nos los haga conocer&nbsp;<a target=\"_blank\" href=\"https://github.com/mycozycloud/cozy-webdav/issues\">en Github!</a></p></div><script>window.password = \"" + (jade.escape((jade.interp = password) == null ? '' : jade.interp)) + "\";</script><script src=\"javascripts/vendor.js\"></script><script src=\"javascripts/app.js\" onload=\"require('initialize');\"></script></body></html>");;return buf.join("");
}