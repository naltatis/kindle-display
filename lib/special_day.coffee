ical = require "ical"
fs = require "fs"

days = {}

simpleDate = (date) ->
  date.getFullYear()+"-"+date.getMonth()+"-"+date.getDate()

read = (filename) ->
  string = fs.readFileSync "./#{filename}.ics", "utf8"
  for key, value of ical.parseICS(string)
    if value? and value.start? and value.summary?
      date = simpleDate(value.start)
      days[date] ?= []
      days[date].push
        type: filename
        name: value.summary.val || value.summary
        url: value.url

read("namenstage")
read("sondertage")

today = (date) ->
  days[simpleDate(date)]

module.exports = today