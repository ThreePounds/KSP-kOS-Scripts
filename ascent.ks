//#include "init.ks"
//#include "lib/equipment.ks"
//#include "lib/navigation.ks"
//#include "lib/debug.ks"
@lazyGlobal off.
printToTerminal("===ascent=== V0.0.0").

parameter targetTurnAltitude.
parameter exponent.

local startTurnAltitude is ship:altitude.
local loopTime is time:seconds.
local activeEngines is getEnginesStage().
local targetHeading is 90. // 90 = east
local targetRoll is vAxisAng(ship:facing:upvector, north:vector, vCrs(north:vector, up:vector)). // preserving inital roll
lock targetPitch to getTurnPitch.
lock targetDir to lookDirUp(north:vector, up:vector) * R(-targetPitch, targetHeading, targetRoll).


printToTerminal("Locking steering to straight up. Preserving roll").
printToTerminal("Roll is: " + round(targetRoll,1) + "°").
lock steering to targetDir.
printToTerminal("Target Turn Altitude is: " + targetTurnAltitude).
local targetDebugVec is drawDebugVector({return 5 * targetDir:vector.}, "Steering", cyan, true).

function getTurnPitch {    
    local turnProgress is min(1,max(0,(altitude - startTurnAltitude) / targetTurnAltitude)).
    local pitchCurve is 90*(cos(90 * turnProgress)) ^ exponent.
    return choose pitchCurve if altitude > startTurnAltitude else 90.
}

until ship:stagenum = 0 {
    set loopTime to time:seconds.
    runStagingCheck().
    if loopTime = time:seconds { wait 0. }
}

unlock throttle.
unlock steering.

function runStagingCheck {
    local flamedOutEngines is getEnginesStatus(activeEngines, "Flame-Out").
    if not flamedOutEngines:empty {
        printToTerminal("Flameout detected on Engines:").
        for engine in flamedOutEngines {
            printToTerminal(engine:title).
        }
        printToTerminal("Staging.").
        stage.
        set activeEngines to getEnginesStage().
        printToTerminal("Stage " + ship:stagenum + " activated.").
        printToTerminal("Now managing engines:").
        for engine in activeEngines {
            printToTerminal(engine:title).
        }
    }
}