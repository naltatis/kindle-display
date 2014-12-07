ical = require "ical"
fs = require "fs"

class SpecialDay
  constructor: (@opts) ->
    @_addDays(@_readIcal("./namenstage.ics"), "namenstag")
    @_addDays(@_readIcal("./sondertage_de.ics"), "sondertag")

  data: (cb) ->
    cb(null, @days[@_simpleDate(new Date())])

  _readIcal: (file) ->
    string = fs.readFileSync file, "utf8"
    ical.parseICS(string)

  _simpleDate: (date) ->
    date.getFullYear()+"-"+date.getMonth()+"-"+date.getDate()

  _addDays: (icalEvents, type) ->
    @days ||= {}
    for key, value of icalEvents
      if value? and value.start? and value.summary?
        date = @_simpleDate(value.start)
        @days[date] ?= []
        @days[date].push
          type: type
          name: value.summary.val || value.summary
          url: value.url

module.exports = SpecialDay