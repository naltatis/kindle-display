ical = require "ical"
fs = require "fs"

letters =
  "Neumond": "new"
  "Zunehmender Mond": "grow"
  "Vollmond": "full"
  "Abnehmender Mond": "shrink"

simpleDate = (date) ->
  date.getFullYear()+"-"+date.getMonth()+"-"+date.getDate()

icalString = fs.readFileSync "./moon.ics", "utf8"
events = {}
for key, value of ical.parseICS(icalString)
  if value? and value.start?
    date = simpleDate(value.start)
    phase = value.summary
    if letters[phase]?
      events[date] = letters[phase]

module.exports = events