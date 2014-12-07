sqlite3 = require "sqlite3"

class Uvr
  constructor: (conf) ->
    @db = new sqlite3.Database conf.db

  data: (cb) ->
    @db.get "SELECT round(aussen) as aussen FROM uvr ORDER BY timestamp DESC LIMIT 1", cb

module.exports = Uvr
