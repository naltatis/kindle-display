sqlite3 = require "sqlite3"
db = new sqlite3.Database "../homestats.db"

get = (cb) ->
  db.get "SELECT round(aussen) as aussen FROM uvr ORDER BY timestamp DESC LIMIT 1", cb

module.exports =
  get: get
