@LAZYGLOBAL off.

local telemetrylog_file is "".
local logging_interval is 1.
local last_logging_time is 0.

// START

wait until ship:unpacked.

print "Initializing Telemetry file".
initialize_telemetry().

until false {
    if time:seconds > last_logging_time + logging_interval {
        print "Logging data to file".
        set last_logging_time to time:seconds.
        log_telemetry().
    }
}

function initialize_telemetry {
    local yearstring is time:year + "".
    local daystring is time:day + "".
    local clockstring is time:clock:replace(":","-").

    set telemetrylog_file to "0:/logs/Y" + yearstring:padleft(3):replace(" ","0") + "D" + daystring:padleft(3):replace(" ","0") + "_" + clockstring + ".log".
    local record is "time,longitude,latitude,altitude,temperature,pressure".

    if not exists(telemetrylog_file) {
        create(telemetrylog_file).
    }

    log  record to telemetrylog_file.
}

function log_telemetry {
    local currentTime is round(time:seconds,2).
    local currentLongitude is round(ship:longitude,5).
    local currentLatitude is round(ship:latitude,5).
    local currentAltitude is round(ship:altitude,1).
    local currentemperature is round(kelvinToCelcius(ship:sensors:temp),1).
    local currentPressure is round(ship:sensors:pres,1).
    
    local record is 
        currentTime + "," +
        currentLongitude + "," + 
        currentLatitude + "," + 
        currentAltitude + "," + 
        currentemperature + "," + 
        currentPressure.
    
    log record to telemetrylog_file.
}

function kelvinToCelcius {
    parameter kelvin.
    return kelvin - 273.15.
}