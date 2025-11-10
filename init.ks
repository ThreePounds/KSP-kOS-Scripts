@lazyGlobal off.

printToTerminal("===init=== v0.0.0").

core:doevent("open terminal").
set terminal:width to 80.

function execute {
    parameter missionPhases.
    parameter abortAction.
    for phase in missionPhases {
        if phase() {
            if not abortAction() {
                printToTerminal("abort ended succesfully.").  
            } else {
                printToTerminal("abort failed.").
                break.              
            }
        }
        printToTerminal("phase ended succesfully.").
    }
}

function loadScript {
    parameter file.
    local localFilePath is path("1:/" + file).
    if exists(localFilePath) { return localFilePath.}
    local archiveFilePath is path("0:/" + file).
    printToTerminal("Copying: " + archiveFilePath).
    wait until checkConnection().
    copyPath(archiveFilePath, localFilePath).
    printToTerminal("Copied to: " + localFilePath).
    return localFilePath.
}

function checkConnection {
    return homeConnection:isconnected.
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