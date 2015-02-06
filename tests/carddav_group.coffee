helpers = require './helpers'
should = require('chai').Should()
xmldoc = require 'xmldoc'
Contact = require "#{helpers.prefix}server/models/contact"

describe 'Carddav support - groups', ->

    before helpers.createRequests
    before helpers.cleanDB
    before helpers.makeDAVAccount
    before helpers.startServer
    before helpers.createContact 'Bob'
    before helpers.createContact 'Steve', ['group1']
    before ->
        url = '/public/sync/addressbooks/me/group1/'
        @bobHref   = url + @contacts['Bob'].id   + '.vcf'
        @steveHref = url + @contacts['Steve'].id + '.vcf'

    after  helpers.closeServer
    after  helpers.cleanDB

    ### Not tested because part of jsDAV
       OPTIONS /public/sync/addressbooks/me/all-contacts/
       PROPFIND /public/sync/addressbooks/me/all-contacts/ DEPTH=0
    ###



    describe 'Android PROPFIND /public/sync/addressbooks/me/group1/ D=1', ->

        url = '/public/addressbooks/me/group1/'
        before helpers.send 'PROPFIND', url, """
            <?xml version="1.0" encoding="utf-8" ?>
            <A:propfind xmlns:A="DAV:">
                <A:prop>
                    <A:getcontenttype/>
                    <A:getetag/>
                </A:prop>
            </A:propfind>
        """, depth: 1

        it 'contains a ref to each Contacts of group1', ->
            body = new xmldoc.XmlDocument @resbody
            responses = body.childrenNamed 'd:response'
            responses.length.should.equal 2
            hrefs = responses.map (res) -> res.childNamed('d:href').val

            hrefs.should.not.include @bobHref
            hrefs.should.include @steveHref

    describe 'Android REPORT /public/sync/addressbooks/me/group1/', ->

        url = '/public/addressbooks/me/group1/'
        before (done) ->
            helpers.send('REPORT', url, """
                <?xml version="1.0" encoding="utf-8" ?>
                <A:addressbook-multiget xmlns:B="DAV:" xmlns:A="urn:ietf:params:xml:ns:carddav">
                <B:prop>
                    <A:address-data/>
                    <B:getetag/>
                </B:prop>
                <B:href>#{@steveHref}</B:href>
                </A:addressbook-multiget>
            """).call @, done

        it 'contains contacts data', ->

            body = new xmldoc.XmlDocument @resbody
            responses = body.childrenNamed 'd:response'

            results = {}
            for res in responses
                href = res.childNamed('d:href')?.val
                propstat = res.childNamed('d:propstat')
                prop = propstat.childNamed('d:prop')
                card = prop.childNamed('card:address-data').val

                results[href] = card

            results[@steveHref].should.have.string 'steve@test.com'


    describe "Android Create contact in group1", ->

        url = '/public/addressbooks/me/group1/24edbec3-a2db-4b07-97d1-3609d526f4c8.vcf'
        before helpers.send 'PUT', url, """
            BEGIN:VCARD
            VERSION:3.0
            EMAIL;TYPE=INTERNET;TYPE=HOME:stw@test.com
            FN:Steve Wonder
            N:Wonder;Steve;;;
            TEL;TYPE=CELL:+33 1 23 45 67 89
            PRODID:-//dmfs.org//mimedir.vcard//EN
            REV:20131011T070908Z
            UID:24edbec3-a2db-4b07-97d1-3609d526f4c8
            END:VCARD
        """,
            'If-None-Match': '*'
            'Content-Type': 'text/vcard; charset=utf-8'

        it "should work", ->
            @res.statusCode.should.equal 201
            @resbody.should.have.length 0

        created = null
        it "and contact has been created in db", (done) ->
            Contact.byURI '24edbec3-a2db-4b07-97d1-3609d526f4c8.vcf', (err, contact) ->
                should.not.exist err
                created = contact[0]
                created.should.have.property 'carddavuri'
                done()
        it "and contact should have group name in tags", ->
            should.exist created.tags
            if created.tags
                created.tags.should.contain 'group1'

        it "and contact's vcf should include the UID property", (done) ->
            created.toVCF (err, vCardOutput) ->
                vCardOutput.indexOf('UID').should.not.equal -1
                done()

    describe "Android Check contact creation", ->

        url = '/public/addressbooks/me/group1/24edbec3-a2db-4b07-97d1-3609d526f4c8.vcf'
        before helpers.send('HEAD', url, "")

        it "should return the contact E-tag", ->
            @res.statusCode.should.equal 200
            @res.headers.should.include.keys('etag')
            @etag = @res.headers['etag']

    describe "Android update created Contact", ->

        url = '/public/addressbooks/me/group1/24edbec3-a2db-4b07-97d1-3609d526f4c8.vcf'
        before (done) ->
            helpers.send('PUT', url, """
                BEGIN:VCARD
                VERSION:3.0
                FN:Steve
                EMAIL;TYPE=INTERNET;TYPE=HOME:stw@test.com
                N:Wonder;;;;
                TEL;TYPE=CELL:+33 1 23 45 67 89
                PRODID:-//dmfs.org//mimedir.vcard//EN
                REV:20131011T070908Z
                UID:24edbec3-a2db-4b07-97d1-3609d526f4c8
                END:VCARD
            """, 'If-Match': @etag).call @, done

        it "should work", ->
            @res.statusCode.should.equal 200
            @resbody.should.have.length 0

        updated = null
        it "and contact has been updated in db", (done) ->
            Contact.byURI '24edbec3-a2db-4b07-97d1-3609d526f4c8.vcf', (err, contact) ->
                should.not.exist err
                updated = contact[0]
                updated.should.have.property 'carddavuri'
                done()

        it "and contact should have group name in tags", ->
            should.exist updated.tags
            if updated.tags
                updated.tags.should.contain 'group1'
