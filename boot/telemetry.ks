@LAZYGLOBAL off.

local telemetryLogPath is path("0:/log/").
local loggingInterval is 1.
local lastLoggingTime is 0.

local hasTempSensor is shipHasPart("sensorThermometer").
local hasPresSensor is shipHasPart("sensorBarometer").

wait until ship:unpacked.

initializeTelemetry().

until false {
    
    if time:seconds > lastLoggingTime + loggingInterval {
        print "Logging data to file".
        set lastLoggingTime to time:seconds.
        logTelemetry().
    }
    wait 0.
}

function initializeTelemetry {
    local yearstring is time:year + "".
    local daystring is time:day + "".
    local clockstring is time:clock:replace(":","-").

    set telemetryLogPath to telemetryLogPath:combine("Y" + yearstring:padleft(3):replace(" ","0") + "D" + daystring:padleft(3):replace(" ","0") + "_" + clockstring + ".csv").
    local record is "time,longitude,latitude,altitude".

    if not exists(telemetryLogPath) {
        create(telemetryLogPath).
    }

    log record to telemetryLogPath.
}

function logTelemetry {
    local currentTime is round(time:seconds,2).
    local currentLongitude is round(ship:longitude,5).
    local currentLatitude is round(ship:latitude,5).
    local currentAltitude is round(ship:altitude,1).
    local currentTemperature is -1.
    local currentPressure is -1.
    
    if hasTempSensor {
        set currentTemperature to round(kelvinToCelcius(ship:sensors:temp),1).   
    }

    if hasPresSensor{
        set currentPressure to round(ship:sensors:pres,1).
    }
    
    local record is 
        currentTime + "," +
        currentLongitude + "," + 
        currentLatitude + "," + 
        currentAltitude + "," + 
        currentTemperature + "," + 
        currentPressure.
    
    log record to telemetryLogPath.
}

function kelvinToCelcius {
    parameter kelvin.
    return kelvin - 273.15.
}

function shipHasPart {
    parameter part.
    local partlist is ship:partsnamed(part).
    return not partlist:empty.
}