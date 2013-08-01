# Interface = require 'jsdav/lib/CardDAV/interfaces/iBackend'
Exc       = require 'jsDAV/lib/shared/exceptions'

handle    = (err) ->
    console.log err
    return new Exc err.message || err

module.exports = class CozyCardDAVBackend

    constructor: (@Contact) ->

    getAddressBooksForUser: (principalUri, callback) ->
        book = 
            id: 'all-contacts'
            uri: 'all-contacts'
            ctag: 0 # ?
            principaluri: principalUri
            "{DAV:}displayname": 'Cozy Contacts'

        return callback null, [book]

    getCards: (addressbookId, callback) ->
        @Contact.all (err, contacts) ->
            return callback handle err if err

            callback null, contacts.map (contact) ->
                lastmodified: 0
                carddata:     contact.toVCF()
                uri:          contact.id

    getCard: (addressBookId, cardUri, callback) ->
        @Contact.find cardUri, (err, contact) ->
            return callback handle err if err

            callback null, 
                lastmodified: 0
                carddata:     contact.toVCF()
                uri:          contact.id

    createCard: (addressBookId, cardUri, cardData, callback) ->
        @Contact.create @Contact.parse(cardData), (err, contact) ->
            return callback handle err if err

            callback null

    updateCard: (addressBookId, cardUri, cardData, callback) ->
        @Contact.find cardUri, (err, contact) ->
            return callback handle err if err 

            contact.updateAttributes @Contact.parse(cardData), (err, contact) ->
                return callback handle err if err

                callback null

    deleteCard: (addressBookId, cardUri, callback) ->

        @Contact.find cardUri, (err, contact) ->
            return callback handle err if err
            
            contact.destroy (err) ->
                return callback handle err if err

                callback null        
