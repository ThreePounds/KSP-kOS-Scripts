//#include "simpleCountdown.ks"
@lazyGlobal off.

wait until homeConnection:isConnected.

if not exists("init.ks") { copyPath("0:init.ks", "1:"). }
runOncePath("init.ks").

// libaries
for lib in list(
){ runOncePath(loadScript(lib)). }

// mission scripts
for script in list(
    "simpleCountdown.ks"
) loadScript(script).

local missionPhases is list(
    { wait 1. }, // 0
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