tagsView =
    map    : (doc) ->
        doc.tags?.forEach? (tag, index) ->
            type = if index is 0 then 'calendar' else 'tag'
            emit [type, tag], true
    reduce : (key, values, rereduce) -> true

byCalendar = (doc) ->
    if doc.tags?.length > 0
        emit doc.tags[0], doc
    else
        emit null, doc

module.exports =
    cozyinstance:
        all: (doc) -> emit doc._id, doc
    webdavaccount:
        all: (doc) -> emit doc._id, doc
    contact:
        all: (doc) -> emit doc._id, doc
        byURI: (doc) -> emit (doc.carddavuri or doc._id + '.vcf'), doc
    event:
        all: (doc) -> emit doc._id, doc
        byURI: (doc) -> emit (doc.caldavuri or doc._id + '.ics'), doc
        tags: tagsView
        byCalendar: byCalendar
    user:
        all: (doc) -> emit doc._id, doc
