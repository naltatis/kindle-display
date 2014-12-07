class TodayIcon
  constructor: (conf) ->
    @numberOfIcons = conf.number_of_icons

  data: (cb) ->
    iconNumber = @_dayOfYear() % @numberOfIcons
    result = "/images/icons/#{iconNumber}.svg"
    cb(null, result)

  _dayOfYear: ->
    now = new Date()
    onejan = new Date(now.getFullYear(), 0, 1)
    Math.ceil (now - onejan) / 86400000

module.exports = TodayIcon