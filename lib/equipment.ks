//#include "../init.ks"
@lazyGlobal off.
printToTerminal("===equipment=== v0.0.0").

function failedEngines {
    parameter engineList.
    local failureList is list().
    for engine in engineList {
        local engineStatus is engine:getmodule("ModuleEnginesFx"):getfield("status").
        if engineStatus = "<color=orange>Failed</color>" { failedEngines:add(engine). }
    }
    return failureList.
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