ical = require "ical"
fs = require "fs"

phases =
  "Neumond": "new"
  "Zunehmender Mond": "grow"
  "Vollmond": "full"
  "Abnehmender Mond": "shrink"

class Moon
  constructor: (conf) ->
    @result = @_transformEvents(@_readIcal(conf.file))

  data: (cb) ->
    nextResults = {}
    nextResults[day] = @result[day] for day in @_nextDays(5)
    cb(null, nextResults)

  _nextDays: (number) ->
    now = new Date().getTime()
    msPerDay = 24*60*60*1000
    (@_simpleDate(new Date(now + i*msPerDay)) for i in [0..number-1])

  _simpleDate: (date) ->
    date.getFullYear()+"-"+date.getMonth()+"-"+date.getDate()

  _readIcal: (file) ->
    string = fs.readFileSync file, "utf8"
    ical.parseICS(string)

  _transformEvents: (icalEvents) ->
    events = {}
    for key, value of icalEvents
      if value? and value.start?
        date = @_simpleDate(value.start)
        name = value.summary
        if phases[name]?
          events[date] = phases[name]
    events

module.exports = Moon