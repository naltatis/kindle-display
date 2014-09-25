Forecast = require "forecast"

forecast = new Forecast(
  service: 'forecast.io'
  key: '3efcd3a4b7dbe5e7fc7584550cffc22a'
  units: 'celcius'
  cache: true
  ttl: minutes: 15
)

weekday = (timestamp) ->
  dayIndex = new Date(timestamp*1000).getDay()
  days = ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"]
  days[dayIndex]

simpleDate = (timestamp) ->
  date = new Date(timestamp*1000)
  date.getFullYear()+"-"+date.getMonth()+"-"+date.getDate()

get = (long, lat, cb) ->
  forecast.get [long, lat], (err, data) ->
    weather = {}
    weather.forecast = []
    return cb(null, weather) if err? or not data?

    weather.today =
      current: data.currently.temperature
      min: data.daily.data[0].temperatureMin
      max: data.daily.data[0].temperatureMax
      icon: data.currently.icon
    for entry, i in data.daily.data
      if i < 5
        weather.forecast.push {
          day: weekday(entry.time)
          date: simpleDate(entry.time)
          icon: entry.icon
          max: entry.temperatureMax
          min: entry.temperatureMin
        }
    weather.temperatureMin = Math.floor weather.forecast.reduce((prev, current) ->
      if prev? then Math.min(prev, current.min) else current.min
    , null)
    weather.temperatureMax = Math.ceil weather.forecast.reduce((prev, current) ->
      if prev? then Math.max(prev, current.max) else current.max
    , null)

    cb err, weather


module.exports = {
  get: get
}
