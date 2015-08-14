sqlite3 = require "sqlite3"

class TempDelta
  constructor: (conf) ->
    @db = new sqlite3.Database conf.db

  data: (cb) ->
    @db.get """
      SELECT
        ROUND(innen_now - innen_before, 2) innen,
        ROUND(aussen_now - aussen_before, 2) aussen
      FROM
        (SELECT t3_abluft as innen_before FROM pluggit ORDER BY id DESC LIMIT 20, 1),
        (SELECT t3_abluft as innen_now FROM pluggit ORDER BY id DESC LIMIT 1, 1),
        (SELECT aussen as aussen_before FROM uvr ORDER BY id DESC LIMIT 20, 1),
        (SELECT aussen as aussen_now FROM uvr ORDER BY id DESC LIMIT 1, 1)
    """, cb

module.exports = TempDelta


