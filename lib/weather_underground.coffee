request = require "superagent"
LRU = require "lru-cache"

days = ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"]

class Weather
  constructor: (conf) ->
    @cache = LRU(length: 1, maxAge: 1000 * 60 * conf.cacheMin)
    @wundergroundApi = "http://api.wunderground.com/api/#{conf.apiKey}/conditions/hourly/forecast10day/lang:DE/q/#{conf.location}.json"

  data: (cb) ->
    data = @cache.get("data")
    return cb(null, data) if data?
    @_getWeather (err, result) =>
      @cache.set("data", result)
      cb(err, result)

  _weekday: (timestamp) ->
    dayIndex = new Date(timestamp*1000).getDay()
    days[dayIndex]

  _simpleDate: (timestamp) ->
    date = new Date(timestamp*1000)
    date.getFullYear()+"-"+date.getMonth()+"-"+date.getDate()

  _getWeather: (cb) ->
    request.get @wundergroundApi, (res) =>
      data = res.body
      weather = {}
      weather.forecast = []
      weather.rain = {probability: [], hour: []}
      weather.wind = {speed: [], direction: [], hour: []}

      weather.today =
        current: data.current_observation.temp_c
        min: parseInt(data.forecast.simpleforecast.forecastday[0].low.celsius, 10)
        max: parseInt(data.forecast.simpleforecast.forecastday[0].high.celsius, 10)
        icon: data.current_observation.icon

      for entry, i in data.forecast.simpleforecast.forecastday
        if i < 5
          weather.forecast.push {
            day: @_weekday(entry.date.epoch)
            date: @_simpleDate(entry.date.epoch)
            icon: entry.icon
            max: parseInt(entry.high.celsius, 10)
            min: parseInt(entry.low.celsius, 10)
          }

      for entry, i in data.hourly_forecast
        if i < 13
          weather.rain.probability.push(Math.min(99, parseInt(entry.pop, 10)))
          weather.wind.speed.push(parseInt(entry.wspd.metric, 10))
          weather.rain.hour.push(if i%6 is 0 then entry.FCTTIME.hour else "")
          weather.wind.hour.push(if i%6 is 0 then entry.FCTTIME.hour else "")

      weather.probabilityMax = Math.floor weather.rain.probability.reduce((prev, current) ->
        if prev? then Math.max(prev, current) else current
      , null)
      weather.windDirection = parseInt(data.hourly_forecast[0].wdir.degrees, 10)
      weather.windSpeedMax = Math.floor weather.wind.speed.reduce((prev, current) ->
        if prev? then Math.max(prev, current) else current
      , null)
      weather.windSpeedMax = Math.ceil(weather.windSpeedMax / 5) * 5
      weather.rain.probability = [0] if weather.probabilityMax < 20
      weather.wind.speed = if weather.windSpeedMax < 20 then [0] else (100/weather.windSpeedMax*speed for speed in weather.wind.speed)
      weather.temperatureMin = Math.floor weather.forecast.reduce((prev, current) ->
        if prev? then Math.min(prev, current.min) else current.min
      , null)
      weather.temperatureMax = Math.ceil weather.forecast.reduce((prev, current) ->
        if prev? then Math.max(prev, current.max) else current.max
      , null)
      cb null, weather

module.exports = Weather