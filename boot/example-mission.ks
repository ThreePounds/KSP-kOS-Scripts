//#include "simpleCountdown.ks"
@lazyGlobal off.

wait until homeConnection:isConnected.

// libaries
for lib in list(
    "init.ks"
){
    if not exists(lib) {copyPath("archive:" + lib, path():combine(lib)).}
    runOncePath(lib).
}

// mission scripts
for script in list(
    "simpleCountdown.ks"
) {if not exists(script) {copypath("archive:" + script, path():combine(script)).}}

local missionPhases is list(
    { run "simpleCountdown"(5). }, // 0
    { wait 1. }, // 1
    { wait 1. }, // 2
    { wait 1. }, // 3
    { wait 1. }, // 4
    { wait 1. }  // 5
).

local abortProcedures is lex(
    "padAbort", { printToTerminal("Quick! Grab a fire extinguisher!!!"). }
).

execute(missionPhases, abortProcedures).