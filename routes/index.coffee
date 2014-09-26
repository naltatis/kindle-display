express = require "express"
weather = require "../lib/uweather"
pluggit = require "../lib/pluggit"
uvr = require "../lib/uvr"
awigo = require "../lib/awigo"
moon = require "../lib/moon"
specialDay = require "../lib/special_day"

Date::getDayOfYear = ->
  onejan = new Date(@getFullYear(), 0, 1)
  Math.ceil (this - onejan) / 86400000

router = express.Router()

router.get "/", (req, res) ->
  model = {}
  model.awigo = awigo
  model.moon = moon
  model.icon = new Date().getDayOfYear() % 153
  model.specialDay = specialDay(new Date())
  weather.get (err, data) ->
    return res.send(500, err) if err?
    model.weather = data
    pluggit.get (err, data) ->
      return res.send(500, err) if err?
      model.pluggit = data
      uvr.get (err, data) ->
        return res.send(500, err) if err?
        model.uvr = data
        res.render "index", model

module.exports = router