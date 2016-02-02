request = require "superagent"

class Vertretungsplan
  days: ["mo", "di", "mi", "do", "freitag"]

  constructor: (conf) ->
    @url = conf.url

  _day: ->
    date = new Date()
    hour = date.getHours()
    day = date.getDay()
    return @days[day] if hour > 16
    return @days[day-1] if hour < 9

  _url: (day) ->
    @url.replace "{day}", day

  _check: (url, cb) ->
    request
      .get(url)
      .end (err, res) ->
        cb(err, res.ok)

  data: (cb) ->
    day = @_day()
    return cb(null) if not day?
    url = @_url(day)
    @_check url, (err, success) ->
      cb(err, if success then url else null)

module.exports = Vertretungsplan
