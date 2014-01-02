module.exports =
    cozyinstance:
        all: (doc) -> emit doc._id, doc
    webdavaccount:
        all: (doc) -> emit doc._id, doc
    contact:
        all: (doc) -> emit (doc.caldavuri or doc._id + '.ics'), doc
    alarm:
        all: (doc) -> emit (doc.carddavuri or doc._id + '.vcf'), doc
    event:
        all: (doc) -> emit doc._id, doc
