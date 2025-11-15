//#include "init.ks"
//#include "lib/equipment.ks"
@lazyGlobal off.

local startTurnAltitude is 500.
local targetTurnAltitude is body:atm:height * 0.9.
local targetHeading is 90.
local targetPitch is 90.
local targetRoll is 0.

lock targetDir to lookDirUp(north:vector, up:vector) * R(targetPitch, targetHeading, targetRoll).

printToTerminal("===ascent=== V0.0.0").

printToTerminal("Locking steering to straight up. Preserving roll").
lock steering to targetRoll.

printToTerminal("Waiting for airspeed to build.").
wait until ship:verticalspeed > 200.