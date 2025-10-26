@LAZYGLOBAL off.

local telemetryLogPath is path("0:/log/").
local loggingInterval is 1.
local lastLoggingTime is 0.

local hasTempSensor is FALSE.
local hasPresSensor is FALSE.

wait until ship:unpacked.

print "checking vessel".
checkForSensors().
if hasTempSensor {
    print "Found Temperature sensor, logging.".
} else {
    print "No Temperature sensor found.".
}
if hasPresSensor {
    print "Found Pressure sensor, logging.".
} else {
    print "No Pressure sensor found.".
}

print "Initializing Telemetry file".
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

    log  record to telemetryLogPath.
}

function logTelemetry {
    local currentTime is round(time:seconds,2).
    local currentLongitude is round(ship:longitude,5).
    local currentLatitude is round(ship:latitude,5).
    local currentAltitude is round(ship:altitude,1).
    local currenTemperature is -1.
    local currentPressure is -1.
    
    if hasTempSensor {
        set currenTemperature to round(kelvinToCelcius(ship:sensors:temp),1).   
    }

    if hasPresSensor{
        set currentPressure to round(ship:sensors:pres,1).
    }
    
    local record is 
        currentTime + "," +
        currentLongitude + "," + 
        currentLatitude + "," + 
        currentAltitude + "," + 
        currenTemperature + "," + 
        currentPressure.
    
    log record to telemetryLogPath.
}

function kelvinToCelcius {
    parameter kelvin.
    return kelvin - 273.15.
}

function checkForSensors {
    local tempSensors is ship:partsnamed("sensorThermometer").
    local presSensors is ship:partsnamed("sensorBarometer").

    set hasTempSensor to not tempSensors:empty.
    set hasPresSensor to not presSensors:empty.
}