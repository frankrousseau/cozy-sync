// Generated by CoffeeScript 1.7.1
var CozyCardDAVBackend, Exc, WebdavAccount, axon, handle,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Exc = require('jsDAV/lib/shared/exceptions');

WebdavAccount = require('../models/webdavaccount');

axon = require('axon');

handle = function(err) {
  console.log(err);
  return new Exc.jsDAV_Exception(err.message || err);
};

module.exports = CozyCardDAVBackend = (function() {
  function CozyCardDAVBackend(Contact) {
    this.Contact = Contact;
    this.saveLastCtag = __bind(this.saveLastCtag, this);
    this.getLastCtag((function(_this) {
      return function(err, ctag) {
        var onChange, socket;
        _this.ctag = ctag + 1;
        _this.saveLastCtag(_this.ctag);
        onChange = function() {
          _this.ctag = _this.ctag + 1;
          return _this.saveLastCtag(_this.ctag);
        };
        socket = axon.socket('sub-emitter');
        socket.connect(9105);
        return socket.on('contact.*', onChange);
      };
    })(this));
  }

  CozyCardDAVBackend.prototype.getLastCtag = function(callback) {
    return WebdavAccount.first(function(err, account) {
      return callback(err, (account != null ? account.cardctag : void 0) || 0);
    });
  };

  CozyCardDAVBackend.prototype.saveLastCtag = function(ctag, callback) {
    if (callback == null) {
      callback = function() {};
    }
    return WebdavAccount.first((function(_this) {
      return function(err, account) {
        if (err || !account) {
          return callback(err);
        }
        return account.updateAttributes({
          cardctag: ctag
        }, function() {});
      };
    })(this));
  };

  CozyCardDAVBackend.prototype.getAddressBooksForUser = function(principalUri, callback) {
    var book;
    book = {
      id: 'all-contacts',
      uri: 'all-contacts',
      principaluri: principalUri,
      "{http://calendarserver.org/ns/}getctag": this.ctag,
      "{DAV:}displayname": 'Cozy Contacts'
    };
    return callback(null, [book]);
  };

  CozyCardDAVBackend.prototype.getCards = function(addressbookId, callback) {
    return this.Contact.all(function(err, contacts) {
      if (err) {
        return callback(handle(err));
      }
      return callback(null, contacts.map(function(contact) {
        return {
          lastmodified: 0,
          carddata: contact.toVCF(),
          uri: contact.getURI()
        };
      }));
    });
  };

  CozyCardDAVBackend.prototype.getCard = function(addressBookId, cardUri, callback) {
    return this.Contact.byURI(cardUri, function(err, contact) {
      if (err) {
        return callback(handle(err));
      }
      if (!contact.length) {
        return callback(null);
      }
      contact = contact[0];
      return callback(null, {
        lastmodified: 0,
        carddata: contact.toVCF(),
        uri: contact.getURI()
      });
    });
  };

  CozyCardDAVBackend.prototype.createCard = function(addressBookId, cardUri, cardData, callback) {
    var contact;
    contact = this.Contact.parse(cardData);
    contact.carddavuri = cardUri;
    return this.Contact.create(contact, function(err, contact) {
      if (err) {
        return callback(handle(err));
      }
      return callback(null);
    });
  };

  CozyCardDAVBackend.prototype.updateCard = function(addressBookId, cardUri, cardData, callback) {
    return this.Contact.byURI(cardUri, (function(_this) {
      return function(err, contact) {
        var data;
        if (err) {
          return callback(handle(err));
        }
        if (!contact.length) {
          return callback(handle('Not Found'));
        }
        contact = contact[0];
        data = _this.Contact.parse(cardData).toObject();
        data.id = contact._id;
        data.carddavuri = cardUri;
        return contact.updateAttributes(data, function(err, contact) {
          if (err) {
            return callback(handle(err));
          }
          return callback(null);
        });
      };
    })(this));
  };

  CozyCardDAVBackend.prototype.deleteCard = function(addressBookId, cardUri, callback) {
    return this.Contact.byURI(cardUri, function(err, contact) {
      if (err) {
        return callback(handle(err));
      }
      contact = contact[0];
      return contact.destroy(function(err) {
        if (err) {
          return callback(handle(err));
        }
        return callback(null);
      });
    });
  };

  return CozyCardDAVBackend;

})();
