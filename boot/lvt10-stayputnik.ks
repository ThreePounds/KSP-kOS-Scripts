//#include "launch.ks"
//#include "ascent.ks"
//#include "deployExperiments"
@lazyGlobal off.

local targetAltitude is 100_000.
local ascentCurveExponent is 1.0.

wait until homeConnection:isConnected.

if not exists("init.ks") { copyPath("0:init.ks", "1:"). }
runOncePath("init.ks").

// libaries
for lib in list(
    "lib/equipment.ks",
    "lib/navigation.ks",
    "lib/debug.ks"
){ runOncePath(loadScript(lib)). }

// mission scripts
for script in list(
    "launch.ks",
    "ascent.ks",
    "deployExperiments"
) loadScript(script).

local missionPhases is list(
    { run launch(10). },
    { run ascent(targetAltitude, ascentCurveExponent). },
    { run deployExperiments. } 
).

local abortProcedures is lex(
    // list abort procedures here
).

execute(missionPhases, abortProcedures).