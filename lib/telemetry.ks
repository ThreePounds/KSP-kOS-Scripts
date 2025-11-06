@LAZYGLOBAL off.
print "===lib/telemetry=== V0.0.1".

local telemetryActive is FALSE.

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

    configurationLex:addSensor("time", {return round(time:seconds,3).}).
    configurationLex:addSensor(
        "temperature", 
        {return round(kelvinToCelcius(ship:sensors:temp),1).},
        {return shipHasPart("sensorThermometer").}
    ).

    configurationLex:addSensor(
        "pressure", 
        {return kelvinToCelcius(round(ship:sensors:pres,1)).},
        {return shipHasPart("sensorBarometer").}
    ).

    configurationLex:addSensor("altitude", {return round(ship:altitude,2).}).
    configurationLex:addSensor("longitude", {return round(ship:longitude,5).}).
    configurationLex:addSensor("latitude", {return round(ship:latitude,5).}).
    
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
    local lastSendTime is 0.

    set telemetryPath to telemetryPath:combine(ship:rootpart:uid:tostring + "-" + ship:name:replace(" ","_") + ".csv").
 
    if not exists(telemetryPath) {
        local header is configuration:sensors:keys:join(","). 
        create(telemetryPath).
        set telemetryFile to open(telemetryPath).
        telemetryFile:writeln(header).
    } else { set telemetryFile to open(telemetryPath). }

    checkSensors(configuration).
    set telemetryActive to TRUE.
    when (time:seconds > lastSendTime + configuration:intervall) then {
        local record is list().
        set lastSendTime to time:seconds.
        for telemetrySensor in configuration:sensors:values {
                record:add(choose telemetrySensor:data() if telemetrySensor:isActive else -1).
            }
        telemetryFile:writeln(record:join(",")).
        return telemetryActive.
    }
    on ship:stagenum {
        checkSensors(configuration).
        return telemetryActive.
    }
}

global function stopTelemetry {
    set telemetryActive to FALSE.
}

local function checkSensors {
    parameter configuration.
    for telemetrySensor in configuration:sensors:values {
        set telemetrySensor:isActive to telemetrySensor:isAvailable().
    }
}

local function kelvinToCelcius {
    parameter kelvin.
    return kelvin - 273.15.
}