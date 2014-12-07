sqlite3 = require "sqlite3"

class Pluggit
  constructor: (conf) ->
    @db = new sqlite3.Database conf.db

  data: (cb) ->
    @db.get "SELECT round(t1_aussenluft) as aussen, round(t3_abluft) as innen, fan_speed as speed, bypass FROM pluggit ORDER BY timestamp DESC LIMIT 1", cb

module.exports = Pluggit
