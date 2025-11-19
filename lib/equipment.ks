//#include "../init.ks"
@lazyGlobal off.
printToTerminal("===equipment=== v0.0.0").

function getEnginesStatus {
    parameter engineList.
    parameter statusName.
    local filteredList is list().
    for engine in engineList {
        local engineStatus is engine:getmodule("ModuleEnginesFx"):getfield("status").
        if engineStatus:contains(statusName) { filteredList:add(engine). }
    }
    return filteredList.
}

function getEnginesStage {
    parameter stagenum is ship:stagenum.
    local engineList is list().
    local filteredEngineList is list().
    list engines in engineList.
    for engine in engineList {
        if engine:stage >= stagenum { filteredEngineList:add(engine). }
    }
    return filteredEngineList.
}