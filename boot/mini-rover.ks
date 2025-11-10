//#include "simpleCountdown.ks"
@lazyGlobal off.

if not exists("1:/init.ks") {copyPath("0:/init.ks", "1:/init.ks").}
runOncePath("init.ks").

printToTerminal("===mini=rover=== V0.0.1").

for file in list(
    "simpleCountdown.ks"
){ runOncePath(loadScript(file)). }

local missionphases is list(
    simpleCountdown@:bind(5),
    { wait 1. },
    { printToTerminal("launching rocket!"). },
    { wait 2. },
    { printToTerminal("last phase"). }
).
local abortAction is { (printToTerminal("Phase exited with error. Aborting program.")). return 0. }.

execute(missionphases, abortAction).

wait 1.

printToTerminal("boot file finished.").