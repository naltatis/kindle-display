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

simpleDate = (date) ->
  date.getFullYear()+"-"+date.getMonth()+"-"+date.getDate()

icalString = fs.readFileSync "./awigo.ics", "utf8"
events = {}
for key, value of ical.parseICS(icalString)
  if value? and value.start?
    date = simpleDate(value.start)
    garbage = value.summary.val
    if not events[date]?
      events[date] = []
    events[date].push {letter: letters[garbage], name: names[garbage]}

module.exports = events