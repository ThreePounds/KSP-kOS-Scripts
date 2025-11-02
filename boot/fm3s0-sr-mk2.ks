//#include "lib/telemetry.ks"
@lazyGlobal off.

local firstStageBurn is 60.
local secondStageBurn is 60.
local scienceExperimentMods is ship:modulesnamed("ModuleScienceExperiment").
local scienceIsDepoloyed is false.
local isAbort is false.
local LF is char(10).


copypath("0:/lib/telemetry","1:/").
runoncepath("telemetry").

wait until ship:unpacked.

when ship:altitude > 85_000 then {
    for mod in scienceExperimentMods {
        mod:deploy().
        print mod:part:title + " deployed.".
        scienceIsDepoloyed on.
    }
}

clearScreen.
print "Launch control and guidance for " + LF + ship:name.
print "Press [1] to launch." + LF + "Press [Abort] at any time to stop launch sequence".

wait until getSingleInput() = "1".

print "Launch Sequence started. Launching in:".

from { local countDown is 10. } until countDown = 0 step { set countDown to countDown - 1. } do {
    wait 1.
    if abort {
        print "Launch aborted.".
        break.
    }
    print countDown.
}

if not abort {
    startTelemetry().
    local launchTime is time:seconds. 
    stage.

    wait until time:seconds > launchTime + firstStageBurn.
    stage.

    wait until time:seconds > launchTime + firstStageBurn + secondStageBurn.
    stage.

    wait until scienceIsDepoloyed.
}

local function getSingleInput {
    until false {
        if terminal:input:haschar {
            return terminal:input:getchar().      
        }
    wait 0.
    }

}