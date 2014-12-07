ical = require "ical"
fs = require "fs"

letters =
  "Gelbe(r) Tonne/Sack": "G"
  "Bioabfall-Tonne": "B"
  "Papier-Tonne": "P"
  "Restmuelltonne": "R"

names =
  "Gelbe(r) Tonne/Sack": "Gelbe Tonne"
  "Bioabfall-Tonne": "Biomüll"
  "Papier-Tonne": "Papiermüll"
  "Restmuelltonne": "Restmüll"

class Awigo
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
        garbage = value.summary.val
        if not events[date]?
          events[date] = []
        events[date].push {letter: letters[garbage], name: names[garbage]}
    events

module.exports = Awigo