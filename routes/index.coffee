express = require "express"
async = require "async"
fs = require "fs"
yaml = require "js-yaml"

config = yaml.safeLoad(fs.readFileSync("./config.yaml"))

plugins = {}
config.plugins.forEach (name) ->
  Plugin = require("../lib/#{name}")
  instance = new Plugin(config[name])
  plugins[name] = (cb) -> instance.data(cb)

router = express.Router()

router.get "/", (req, res) ->
  async.series plugins, (err, model) ->
    #console.log model
    return res.send(500, err) if err?
    res.render "index", model

module.exports = router