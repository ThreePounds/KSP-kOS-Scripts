@lazyGlobal off.
printToTerminal("===init=== v0.0.0").

local persistentFilepath is "persistent.json".
local missionState is lex().

core:doevent("open terminal").
set terminal:width to 80.

function execute {
    parameter missionPhases.
    parameter abortProcedures is lex().
    restoreFromPersisent().
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
        storeInPersistent("missionPhaseIndex", index).
        missionPhases[index]:call.
        // printToTerminal("Phase concluded: " + index).
    }
}

function abortWithMode {
    parameter mode.
    storeInPersistent@:bind("abortMode", mode).
    reboot.
}

function storeInPersistent {
    parameter key.
    parameter value.
    if missionState:haskey(key) {
        set missionState[key] to value.
    } else {
        missionState:add(key, value).
    }
    writeJson(missionState, persistentFilepath).
}

function restoreFromPersisent {
    local requiredKeys is list ("missionPhaseIndex", "abortMode").
    if exists(persistentFilepath) { set missionState to readJson(persistentFilepath). }
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
    copyPath(archiveFilePath, localFilePath).
    printToTerminal("Copied to: " + localFilePath).
    return localFilePath.
}

function printToTerminal {
    local stringList is list().
    until false {
        parameter string is "".
        if string = "" { break. }
        stringList:add(string).
    }
    for string in stringList {
        local myTimeStamp is "[" + time:clock + "]".
        print myTimeStamp + " " + string.
    }
}