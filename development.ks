//#include "init.ks"
//#include "/lib/telemetry.ks"
@lazyGlobal off.

// local myconfig is telemetryConfiguration().
// for s in list("temperature", "pressure", "altitude", "longitude", "latitude") { myconfig:removeSensor(s). }
// myconfig:addSensor().
// startTelemetry().

local engineList is getStageEngines().
until false {
    local failedEngines is failedEngines(engineList).
    if failedEngines:length {
        for engine in failedEngines {
            printToTerminal("Failed engine(s): " + engine).
        }
    } else {
        printToTerminal("All engines nominal.").
    }
    wait 1.
}

function failedEngines {
    parameter engineList.
    local failedEngines is list().
    for engine in engineList {
        local engineStatus is engine:getmodule("ModuleEnginesFx"):getfield("status").
        if engineStatus = "<color=orange>Failed</color>" { failedEngines:add(engine). }
    }
    return failedEngines.
}

function getStageEngines {
    parameter stagenum is ship:stagenum.
    local engineList is list().
    local filteredEngineList is list().
    list engines in engineList.
    for engine in engineList {
        if engine:stage = stagenum { filteredEngineList:add(engine). }
    }
    return filteredEngineList.
}