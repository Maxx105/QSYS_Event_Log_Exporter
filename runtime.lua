json = require("rapidjson")
eventUpdatePoll = Timer.New()
timezones = Controls['TimeZones']
getLog = Controls['GetLog']
status = Controls['Status']
statusTimer = Timer.New()
local eventsArray = {}
local timezonesArray = {}
local timeZoneLocation = ""
local utcOffset = "0"

function getEventsData(tbl, code, data, err, headers)
  print(string.format( "HTTP response from '%s': Return Code=%i; Error=%s", tbl.Url, code, err or "None" ) )
  eventsData = json.decode(data, { pretty=true, sort_keys=sort })
  saveToFile(eventsData)
end

function getTimeZoneOffset(tbl, code, data, err, headers)
  print(string.format( "HTTP response from '%s': Return Code=%i; Error=%s", tbl.Url, code, err or "None" ) )
  dateTimeInfo = json.decode(data)
  utcOffset = string.sub(dateTimeInfo.dateTimeUTC, -5, -3)
end

function saveToFile(data)
  io.output("design/myEvents.csv")
  io.write("SEVERITY,MESSAGE,DATE,CATEGORY,SOURCE\r\n")
  for i, v in ipairs(data.items) do
    io.write(v.severity..","..removeCommas(v.message)..","..convertToReadableDate(v.dateTime)..","..v.category..","..v.source.."\r\n")
  end
  io.close() 
end

function convertToReadableDate(dateTime)
  dateValues = {}
	for w in string.gmatch(dateTime, "%d+") do
    table.insert(dateValues, w)
	end
  dt = {year=dateValues[1], month=dateValues[2], day=dateValues[3], hour=setHourForTimeZone(dateValues[4]), min=dateValues[5], sec=dateValues[6]}
  return os.date("%d %b %Y - %H:%M:%S", os.time(dt))
end

function removeCommas(str)
   return string.gsub(str, ",", "-")
end

function setHourForTimeZone(hour)
  return tonumber(hour)+tonumber(string.sub(utcOffset, 1, 3))
end

function eventsHTTPDownload() 
  eventsArray = {}
  HttpClient.Download { 
    Url = "http://127.0.0.1/api/v0/systems/1/events?page=1&pageSize=1600", 
    Headers = { ["Content-Type"] = "application/json" } , 
    Timeout = 5, 
    EventHandler = getEventsData 
  }
end

function getHTTPDateTime()
  HttpClient.Download { 
    Url = "http://127.0.0.1/api/v0/cores/self/config/time", 
    Headers = { ["Content-Type"] = "application/json" } , 
    Timeout = 5, 
    EventHandler = getTimeZoneOffset
  }
end

getLog.EventHandler = function()
  getHTTPDateTime()
  status.String = "Creating CSV..."
  statusTimer:Start(3)
end

statusTimer.EventHandler = function()
  statusTimer:Stop()
  eventsHTTPDownload()
  status.String = "CSV Created!"
end

status.String = ""
getHTTPDateTime()

