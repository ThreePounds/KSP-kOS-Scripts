//#include "init.ks"
//#include "lib/equipment.ks"
@lazyGlobal off.
printToTerminal("===launch=== V0.0.0").

parameter countDownDuration is 10.

printToTerminal(list(
    "Launch control and guidance for",
    ship:name,
    "Press [1] to start launch sequence.",
    "Press [Abort] at any time to stop launch sequence"
)).

when abort then {
    printToTerminal("Launch aborted!").
    centerHudText("Launch aborted!", 5, red).
    abortWithMode("padAbort").
}

wait until getSingleInput() = "1".

printToTerminal(list(
    "Launch Sequence started",
    "Launching in: " + countDownDuration + " seconds."
)).

for countDown in range(countDownDuration,-1) {
    wait 1.
    centerHudText("T-00:00:" + countDown:tostring:padleft(2):replace(" ","0")).
}
wait 1.
centerHudText("Launch!",5).
printToTerminal("Launch!").

lock throttle to 1.
local launchEngines is getStageEngines(ship:stagenum - 1).
for engine in launchEngines {
    printToTerminal("Activating: " + engine:title).
    engine:activate().
}
wait 0.
if failedEngines(launchEngines):length {
    printToTerminal("Engine failure detected!").
    wait 1.
    abortWithMode("padAbort").
} else { printToTerminal(list("All engines running nominally.", "Releasing launch clamps.")). }
stage.

local function getSingleInput {
    until false {
        if terminal:input:haschar {
            return terminal:input:getchar().      
        }
    wait 0.
    }

}

local function centerHudText {
    parameter string.
    parameter delay is 1.4.
    parameter colour is green.
    local size is 40.
    local upper_center is 2.
    hudtext(
        string,
        delay,
        upper_center,
        size,
        colour,
        false
    ).
}