//#include "simpleCountdown.ks"
@lazyGlobal off.

// if not exists("1:/init.ks") {
    copyPath("0:/init.ks", "1:/init.ks").
    // }
runOncePath("init.ks").

printToTerminal("===mini=rover=== V0.0.1").

for file in list(
    "simpleCountdown.ks"
// ){ runOncePath(loadScript(file)). }
) { copypath("0:/" + file, "1:/" + file). }

local missionPhases is list(
    { run "simpleCountdown"(5). }, // 0
    { wait 1. }, // 1
    { wait 1. }, // 2
    { wait 1. }, // 3
    { wait 1. }, // 4
    { wait 1. } // 5
).
local abortProcedures is lex(
    "padAbort", { printToTerminal("Quick! Grab a fire extinguisher!!!"). }
).

execute(missionPhases, abortProcedures).

deletepath("simpleCountdown").

printToTerminal("boot file finished.").