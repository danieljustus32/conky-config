#!/usr/bin/env lua
-- load the http socket module
http = require("socket.http")
-- load the json module
json = require("json")


api_url = "https://api.openweathermap.org/data/2.5/onecall?"

-- Your lattitude and longitude
LAT = 38.772221
LON = -90.368340


-- metric or imperial
cf = "imperial"

-- get an open weather map api key: http://openweathermap.org/appid
apikey = "8c3b50c4da164a12d5c41a6709ff23cf"

-- measure is °C if metric and °F if imperial
measure = '°' .. (cf == 'metric' and 'C' or 'F')
wind_units = (cf == 'metric' and 'km/h' or 'mph')

-- Unicode weather symbols to use
icons = {
  ["01"] = "☀",
  ["02"] = "🌤",
  ["03"] = "🌥",
  ["04"] = "☁",
  ["09"] = "🌧",
  ["10"] = "🌦",
  ["11"] = "🌩",
  ["13"] = "🌨",
  ["50"] = "🌫",
}

currenttime = os.date("!%Y%m%d%H%M%S")

file_exists = function (name)
    f=io.open(name,"r")
    if f~=nil then
        f:close()
        return true
    else
        return false
    end
end

if file_exists("weather.json") then
    cache = io.open("weather.json","r")
    data = json.decode(cache:read())
    cache:close()
    timepassed = os.difftime(currenttime, data.timestamp)
else
    timepassed = 6000
end

makecache = function (s)
    cache = io.open("weather.json", "w+")
    s.timestamp = currenttime
    save = json.encode(s)
    cache:write(save)
    cache:close()
end

if timepassed < 3600 then
    response = data
else
    weather = http.request(("%slat=%s&lon=%s&exclude=minutely,hourly&units=%s&APPID=%s"):format(api_url, LAT, LON, cf, apikey))
    if weather then
        response = json.decode(weather)
        makecache(response)
    else
        response = data
    end
end

math.round = function (n)
    return math.floor(n + 0.5)
end

degrees_to_direction = function (d)
    val = math.round(d/22.5)
    directions = { [0] = "N", [1] = "NNE", [2] = "NE", [3] = "ENE",
                   [4] = "E", [5] = "ESE", [6] = "SE", [7] = "SSE",
                   [8] = "S", [9] = "SSW", [10] = "SW", [11] = "WSW",
                   [12] = "W", [13] = "WNW", [14] = "NW", [15] = "NNW"
                 }
    return directions[val % 16]
end

temp = response.current.temp
min = response.daily[1].temp.min
max = response.daily[1].temp.max
conditions = response.current.weather[1].description
icon2 = response.current.weather[1].id
icon = response.current.weather[1].icon:sub(1, 2)
humidity = response.current.humidity
wind = response.current.wind_speed
deg = degrees_to_direction(response.current.wind_deg)
sunrise = os.date("%H:%M", response.current.sunrise)
sunset = os.date("%H:%M", response.current.sunset)
forcast_icon = response.daily[2].weather[1].icon:sub(1, 2)
forcast_temp = response.daily[2].temp.day
forcast_conditions = response.daily[2].weather[1].main

conky_text = [[
${font Symbola:size=48}%s ${voffset -10}${font :size=20}${color1}%s${font}${voffset -5}%s${color}
${alignc}${voffset 28} %s

${alignc}High: ${color1}%s%s    ${color}Low: ${color1}%s%s${color}

${alignc}Humidity: ${color1}%s%%${color}
${alignc}Wind: ${color1}%s%s %s${color}

${alignc}Tomorrow:
${alignc}${color}${font Symbola:size=20}%s${font}${color1} %s%s %s${color}

${alignc}${font Symbola:size=20}─${color2}☀${color}─${font}
${alignc}${color1}%s${color} | ${color1}%s${color}
]]
io.write((conky_text):format(icons[icon],
                             math.round(temp),
                             measure,
                             conditions,
                             math.round(max),
                             measure,
                             math.round(min),
                             measure,
                             humidity,
                             math.round(wind),
                             wind_units,
                             deg,
                             icons[forcast_icon],
                             math.round(forcast_temp),
                             measure,
                             forcast_conditions,
                             sunrise,
                             sunset)
)