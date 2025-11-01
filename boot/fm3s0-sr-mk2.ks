//#include "0:/lib/telemetry.ks"
@lazyGlobal off.
local launchTime is time:seconds.

local firstStageBurn is 60.
local secondStageBurn is 60.
local scienceExperimentMods is List().
local scienceIsDepoloyed is false.


copypath("0:/lib/telemetry","1:/").
runoncepath("telemetry").

wait until ship:unpacked.

set scienceExperimentMods to ship:modulesnamed("ModuleScienceExperiment").
when ship:altitude > 85_000 then {
    for mod in scienceExperimentMods {
        mod:deploy().
        print mod:part:title + " deployed.".
        scienceIsDepoloyed on.
    }
}

stage.
startTelemetry().

wait until time:seconds > launchTime + firstStageBurn.

stage.

wait until time:seconds > launchTime + firstStageBurn + secondStageBurn.

stage.

wait until scienceIsDepoloyed.