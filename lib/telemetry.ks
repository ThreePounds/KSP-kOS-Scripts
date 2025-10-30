@LAZYGLOBAL off.

local telemetryActive is FALSE.
local lastSendTime is 0.

global function telemetryConfiguration {
    local configurationLex is LEX().
    local sensorLex is Lex().
   
    configurationLex:add("addSensor", {
        parameter label.
        parameter data is 0.
        parameter isAvailable is {return TRUE.}.
        parameter isActive is FALSE.
        sensorLex:add(label, lex("data", data, "isAvailable", isAvailable, "isActive", isActive)).
    }).

    configurationLex:add("removeSensor", {
        parameter label.
        sensorLex:remove(label).
    }).

    configurationLex:add("intervall", 1).
    configurationLex:add("sensors", sensorLex).

    configurationLex:addSensor("time", {return time:seconds.}).
    configurationLex:addSensor(
        "temperature", 
        {return kelvinToCelcius(ship:sensors:temp).},
        {return shipHasPart("sensorThermometer").}
    ).

    configurationLex:addSensor(
        "pressure", 
        {return kelvinToCelcius(ship:sensors:pres).},
        {return shipHasPart("sensorBarometer").}
    ).

    configurationLex:addSensor("altitude", {return ship:altitude.}).
    configurationLex:addSensor("longitude", {return ship:longitude.}).
    configurationLex:addSensor("latitude", {return ship:latitude.}).
    
    local function shipHasPart {
        parameter part.
        local partlist is ship:partsnamed(part).
        return not partlist:empty.
    }

    return configurationLex.
}

global function startTelemetry {
    parameter telemetryPath is path("0:/log").
    parameter configuration is telemetryConfiguration().

    local telemetryFile is 0.

    set telemetryPath to telemetryPath:combine(ship:rootpart:uid:tostring + "-" + ship:name:replace(" ","_") + ".log").
 
    if not exists(telemetryPath) {
        local isFirst is true.
        local header is "". 
        create(telemetryPath).
        set telemetryFile to open(telemetryPath).
        for key in configuration:sensors:keys {
            if isFirst { isFirst off.} else {set header to header + ",".} 
            set header to header + key.
        }
        telemetryFile:writeln(header).
    } else { set telemetryFile to open(telemetryPath). }

    checkTelemetry(configuration).
    set telemetryActive to TRUE.
    when (time:seconds > lastSendTime + configuration:intervall) then {
        local record is "".
        local isFirst is TRUE.
        set lastSendTime to time:seconds.
        for key in configuration:sensors:keys {
            if isFirst { isFirst off.} else {set record to record + ",".}
            if configuration:sensors[key]:isActive {
                set record to record + configuration:sensors[key]:data().
            } else { 
                set record to record + "null".
            }
        }
        telemetryFile:writeln(record).
        return telemetryActive.
    }

    // on ship:stagenum {
    //     checkTelemetry(configuration).
    // }

}

global function stopTelemetry {
    set telemetryActive to FALSE.
}

local function checkTelemetry {
    parameter configuration.
    for key in configuration:sensors:keys {
        set configuration:sensors[key]:isActive to configuration:sensors[key]:isAvailable().
    }
}

local function kelvinToCelcius {
    parameter kelvin.
    return kelvin - 273.15.
}