express = require "express"
weather = require "../lib/uweather"
pluggit = require "../lib/pluggit"
uvr = require "../lib/uvr"
awigo = require "../lib/awigo"
moon = require "../lib/moon"

router = express.Router()

router.get "/", (req, res) ->
  model = {}
  model.awigo = awigo
  model.moon = moon
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