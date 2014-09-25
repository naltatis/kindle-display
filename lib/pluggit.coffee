sqlite3 = require "sqlite3"
db = new sqlite3.Database "../homestats.db"

get = (cb) ->
  db.get "SELECT round(t1_aussenluft) as aussen, round(t3_abluft) as innen, fan_speed as speed, bypass FROM pluggit ORDER BY timestamp DESC LIMIT 1", cb

module.exports =
  get: get
