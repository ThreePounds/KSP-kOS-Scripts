//#include "launch.ks"
@lazyGlobal off.

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
    "ascent.ks"
) loadScript(script).

local missionPhases is list(
    { run launch(3). },
    { run ascent. }
).

local abortProcedures is lex(
    // list abort procedures here
).

execute(missionPhases, abortProcedures).

// local filelist is list().
// list files in filelist.
// for file in filelist {
//     if not (file = "boot") { deletepath(file). }
// }