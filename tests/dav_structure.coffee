request = require 'request'
helpers = require 'helpers'

send = (method, url, body, headers) -> (done) ->
    headers ?= depth: '0'
    request {method, url, body, headers}, (err, res, resbody) =>
        @err = err
        @res = res
        @resbody = resbody
        done()

describe 'Basic DAV Structure', ->

    before helpers.before
    after  helpers.after

    describe 'Android PROPFIND /public/webdav/', ->

        before send 'PROPFIND', '/public/webdav', """
            <?xml version="1.0" encoding="utf-8" ?>
            <A:propfind xmlns:A="DAV:">
                <A:prop><A:current-user-principal/></A:prop>
            </A:propfind>
        """

        it 'contains a ref to "me" principals', (done) ->
            ref2me = '<d:current-user-principal><d:href>' +
                     '/public/webdav/principals/me/' +
                     '</d:href></d:current-user-principal>'

            @resbody.should.have.string ref2me


    describe 'Android PROPFIND /public/webdav/principals/me/', ->

        before send 'PROFIND', '/public/webdav/principals/me/', """
            <?xml version="1.0" encoding="utf-8" ?>
            <A:propfind xmlns:B="urn:ietf:params:xml:ns:carddav" xmlns:A="DAV:">
                <A:prop><B:addressbook-home-set/></A:prop>
            </A:propfind>
        """

        it 'contains a ref to the addressbook set', (done) ->
            ref = '<card:addressbook-home-set><d:href>' +
                  '/public/webdav/addressbooks/me/' +
                  '</d:href></card:addressbook-home-set>'
            @resbody.should.have.string ref


    describe 'Android PROPFIND /public/webdav/addressbooks/me/', ->

        before send 'PROPFIND', '/public/webdav/addressbooks/me/', """
            <?xml version="1.0" encoding="utf-8" ?>
            <A:propfind xmlns:A="DAV:">
                <A:prop><A:displayname/><A:resourcetype/></A:prop>
            </A:propfind>
        """, depth: 1

        it 'contains ref to the addressbook', (done) ->

            ref = '<d:href>/public/webdav/addressbooks/me/all-contacts/</d:href>'
            refName = '<d:displayname>Cozy Contacts</d:displayname>'
            refType = '<d:resourcetype><d:collection/><card:addressbook/></d:resourcetype>'

            @resbody.should.have.string ref
            @resbody.should.have.string refName
            @resbody.should.have.string refType

