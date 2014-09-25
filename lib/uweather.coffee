request = require "superagent"

wundergroundApi = "http://api.wunderground.com/api/e928b5bda5c7b7b7/conditions/hourly/forecast10day/lang:DE/q/Germany/Bersenbruck.json"

weekday = (timestamp) ->
  dayIndex = new Date(timestamp*1000).getDay()
  days = ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"]
  days[dayIndex]

simpleDate = (timestamp) ->
  date = new Date(timestamp*1000)
  date.getFullYear()+"-"+date.getMonth()+"-"+date.getDate()

get = (long, lat, cb) ->
  request.get wundergroundApi, (res) ->
    data = res.body
    weather = {}
    weather.forecast = []
    weather.rain = {probability: [], hour: []}

    weather.today =
      current: data.current_observation.temp_c
      min: parseInt(data.forecast.simpleforecast.forecastday[0].low.celsius, 10)
      max: parseInt(data.forecast.simpleforecast.forecastday[0].high.celsius, 10)
      icon: data.current_observation.icon

    for entry, i in data.forecast.simpleforecast.forecastday
      if i < 5
        weather.forecast.push {
          day: weekday(entry.date.epoch)
          date: simpleDate(entry.date.epoch)
          icon: entry.icon
          max: parseInt(entry.high.celsius, 10)
          min: parseInt(entry.low.celsius, 10)
        }

    for entry, i in data.hourly_forecast
      if i < 13
        weather.rain.probability.push(Math.min(99, parseInt(entry.pop, 10)))
        weather.rain.hour.push(if i%4 is 0 then entry.FCTTIME.hour else "")

    weather.probabilityMax = Math.floor weather.rain.probability.reduce((prev, current) ->
      if prev? then Math.max(prev, current) else current
    , null)
    weather.temperatureMin = Math.floor weather.forecast.reduce((prev, current) ->
      if prev? then Math.min(prev, current.min) else current.min
    , null)
    weather.temperatureMax = Math.ceil weather.forecast.reduce((prev, current) ->
      if prev? then Math.max(prev, current.max) else current.max
    , null)
    cb null, weather


module.exports = {
  get: get
}
