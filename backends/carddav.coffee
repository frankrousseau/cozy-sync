# Interface = require 'jsdav/lib/CardDAV/interfaces/iBackend'
Exc       = require 'jsdav/lib/shared/exceptions'

handle (err) ->
    console.log err
    return new Exc err.message || err

module.exports = class CozyCardDAVBackend

    constructor: (@Contact) ->

    getAddressBooksForUser: (principalUri, callback) ->
        book = 
            id: 'all-contacts'
            uri: principalUri + '/all-contacts'
            principaluri: principalUri

        return callback [book]

    getCards: (addressbookId, callback) ->

        @Contact.all (err, contacts) ->
            return callback handle err if err

            callback contacts.map (contact) ->
                lastmodified: 0
                carddata:     contact.toVCF()
                uri:          contact.id

    getCard: (addressBookId, cardUri, callback) ->

        @Contact.find cardUri, (err, contact) ->
            return callback handle err if err

            callback
                lastmodified: 0
                carddata:     contact.toVCF()
                uri:          contact.id

    createCard: (addressBookId, cardUri, cardData, callback) ->
        @Contact.create Contact.parse(cardData), (err, contact) ->
            return callback handle err if err

            callback null

    updateCard: (addressBookId, cardUri, cardData, callback) ->
        @Contact.updateAttributes Contact.parse(cardData), (err, contact) ->
            return callback handle err if err

            callback null

    deleteCard: (addressBookId, cardUri, callback) ->

        @Contact.find cardUri, (err, contact) ->
            return callback handle err if err
            
            contact.destroy (err) ->
                return callback handle err if err

                callback null        
