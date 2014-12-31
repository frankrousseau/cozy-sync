fs = require 'fs'
americano = require 'americano-cozy'
VCardParser = require 'cozy-vcard'

module.exports = Contact = americano.getModel 'Contact',
    id            : String
    carddavuri    : String
    fn            : String
    n             : String
    datapoints    : Object
    note          : String
    _attachments  : Object

Contact::getURI = -> @carddavuri or @id + '.vcf'
Contact.all = (cb) -> Contact.request 'byURI', cb
Contact.byURI = (uri, cb) ->
    # see alarms for complexity
    req = Contact.request 'byURI', null, cb
    req.body = JSON.stringify key: uri
    req.setHeader 'content-type', 'application/json'

Contact::toVCF = (callback) ->
    if @_attachments?.picture?
        # we get a stream that we need to convert into a buffer
        # so we can output a base64 version of the picture
        stream = @getFile 'picture', ->
        buffers = []
        stream.on 'data', buffers.push.bind(buffers)
        stream.on 'end', ->
            picture = Buffer.concat(buffers).toString 'base64'
            callback null, VCardParser.toVCF(@, picture)
    else
        callback null, VCardParser.toVCF(@)

# Convert base64 encoded string a jpg file and upload it
# Then clean the temporarily created file
Contact::handlePhoto = (photo, callback) ->
    if photo?
        filePath = "/tmp/#{@id}.jpg"
        fs.writeFile filePath, photo, encoding: 'base64', (err) =>
            @attachFile filePath, name: 'picture', (err) ->
                fs.unlink filePath, callback
    else
        callback null

Contact.parse = (vcf) ->
    parser = new VCardParser()
    parser.read(vcf)
    contact = parser.contacts[0]
    if contact.fn and contact.n
        delete contact.fn
    return new Contact parser.contacts[0]
