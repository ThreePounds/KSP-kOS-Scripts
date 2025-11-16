//#include "init.ks"
//#include "lib/equipment.ks"
//#include "lib/navigation.ks"
//#include "lib/debug.ks"
@lazyGlobal off.

local startTurnAltitude is 1000.
local targetTurnAltitude is body:atm:height * 0.9.
local exponent is 0.5.

local targetHeading is 90. // 90 = east
local targetRoll is vAxisAng(ship:facing:upvector, north:vector, vCrs(north:vector, up:vector)). // preserving inital roll

lock targetPitch to getTurnPitch.
lock targetDir to lookDirUp(north:vector, up:vector) * R(-targetPitch, targetHeading, targetRoll).

printToTerminal("===ascent=== V0.0.0").

printToTerminal("Locking steering to straight up. Preserving roll").
printToTerminal("Roll is: " + round(targetRoll,1) + "°").
lock steering to targetDir.
printToTerminal("Target Turn Altitude is: " + targetTurnAltitude).
local targetDebugVec is drawDebugVector({return 5 * targetDir:vector.}, "Steering", cyan, true).

function getTurnPitch {
    if ship:altitude < startTurnAltitude { return 90. }
    if (ship:altitude - startTurnAltitude) > targetTurnAltitude { return 0. }
    return 90 * (cos(90 * (altitude - startTurnAltitude) / targetTurnAltitude)) ^ exponent.
}

until false {
    wait 0.
}