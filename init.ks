@lazyGlobal off.
printToTerminal("===init=== v0.0.0").

local missionStateFilePath is "missionState.json".
local missionState is lex().

core:doevent("open terminal").
set terminal:width to 80.

function execute {
    parameter missionPhases.
    parameter abortProcedures is lex().
    restoreMissionState().
    local abortMode is missionState:abortMode.
    local missionPhaseIndex is missionState:missionPhaseIndex.
    if abortMode {
        printToTerminal("Abort mode '" + abortMode + "' has been set.").
        if abortProcedures:haskey(abortMode) {
            abortProcedures[abortMode]:call.
            return 0. // todo: decide how to handle continuing after aborting
        } else {
            printToTerminal("No producure for '" + abortMode + "' specified. Terminating.").
            return 0.
        }
    }
    for index in range(missionPhaseIndex, missionPhases:length) {
        printToTerminal("Starting phase: " +  index + " of " + (missionPhases:length - 1)).
        storeMissionState("missionPhaseIndex", index).
        missionPhases[index]:call.
    }
    storeMissionState("missionPhaseIndex", missionPhases:length).
    printToTerminal("Mission finished. Godspeed").
}

function abortWithMode {
    parameter mode.
    storeMissionState("abortMode", mode).
    reboot.
}

function storeMissionState {
    parameter key.
    parameter value.
    if missionState:haskey(key) {
        set missionState[key] to value.
    } else {
        missionState:add(key, value).
    }
    writeJson(missionState, missionStateFilePath).
}

function restoreMissionState {
    local requiredKeys is list ("missionPhaseIndex", "abortMode").
    if exists(missionStateFilePath) { set missionState to readJson(missionStateFilePath). }
    if not missionState:istype("Lexicon") { set missionState to lex(). }
    for key in requiredKeys { 
        if not missionState:haskey(key) { missionState:add(key, 0). }
    }
}

function loadScript {
    parameter file.
    local localFilePath is path("1:/" + file).
    if exists(localFilePath) { return localFilePath.}
    local archiveFilePath is path("0:/" + file).
    printToTerminal("Copying: " + archiveFilePath).
    wait until homeConnection:isconnected.
    if copyPath(archiveFilePath, localFilePath) {
        printToTerminal("Copied to: " + localFilePath).
    } else {
        printToTerminal("Copying failed.").
        return "".
    }
    printToTerminal("Used Storage: " + round(100 * (1 - core:volume:freespace / core:volume:capacity)) + "%").
    return localFilePath.
}

function printToTerminal {
    parameter input.
    local myTimeStamp is "[" + time:clock + "]".
    if input:istype("enumerable") {
        for string in input {
            print myTimeStamp + " " + string.
        }
    } else {
        print myTimeStamp + " " + input.
    }
}