//#include "init.ks"
//#include "lib/navigation.ks"
//#include "lib/simpleCountdown.ks"
//#include "lib/telemetry.ks"
@lazyGlobal off.
print "===simpleProbeLaunch=== V1.0.2".

parameter targetApoapsis, stageDurationsList.

if not exists("1:/init.ks") {copyPath("0:/init.ks", "1:/init.ks").}
runOncePath("init.ks").

printToTerminal("===simpleProbeSuborbitalLaunch=== V1.0.1").

for file in list(
    // "lib/debug.ks",
    "lib/navigation.ks",
    "lib/simpleCountdown.ks",
    "lib/telemetry.ks"
) {runOncePath(loadScript(file)).}

local initialStage is ship:stagenum.
local stageDurations is runningSum(stageDurationsList).
local stageTime is stageDurations:iterator().
stageTime:next().

wait until ship:unpacked.

simpleCountdown().

if abort {
    printToTerminal("Launch aborted!").
    //intentionally crash
    print 0/0.
}

lock throttle to 1.
local launchTime is time:seconds.

// time based staging logic
when time:seconds > launchTime + stageTime:value() then {
    stage.
    printToTerminal("Staging. Stage: " + ship:stagenum).
    return stageTime:next().
}

wait until ship:stagenum = initialStage - 2.
printToTerminal("Starting guided ascent").
lock velHeadingVec to vxcl(up:forevector, ship:velocity:surface):normalized.
lock velHeadingDir to lookDirUp(velHeadingVec, up:forevector).
local initalPitch is vAxisAng(
    ship:velocity:surface:normalized,
    -up:forevector,
    velHeadingVec
).
local initialApoasis is ship:orbit:apoapsis.
// lerp pitch to 0 when ship:apoapsis = targetApopsis
lock targetPitch to (initalPitch * (targetApoapsis - ship:orbit:apoapsis)) / (targetApoapsis - initialApoasis). 
lock targetDir to velHeadingDir * R(targetPitch,0,0).
lock steering to targetDir.

until ship:altitude > 65_000 {
    printDebug().
    wait 0.
}

printToTerminal("Restarting guidance using orbital velocity").
lock velHeadingVec to vxcl(up:forevector, ship:velocity:orbit):normalized.
lock velHeadingDir to lookDirUp(velHeadingVec, up:forevector).
set initalPitch to vAxisAng(
    ship:velocity:orbit:normalized,
    -up:forevector,
    velHeadingVec
).
set initialApoasis to ship:orbit:apoapsis.

until ship:verticalspeed < 0 {
    printDebug().
    wait 0.
}

printToTerminal("Activating terminal guidance").
unlock targetPitch.
local targetPitch to 0.

until ship:periapsis > 75_000 {
    printDebug().
    wait 0.
}

printToTerminal("Orbital velocity reached").
lock throttle to 0.
printToTerminal("Script complete. Goodbye").
wait 10.
stage.

function runningSum {
    parameter inputList.
    local outputList is List().
    local sum is 0.
    for item in inputList {
        set sum to sum + item.
        outputList:add(sum).
    }
    return outputList.
}

function printDebug {
    print "┌─────────────────┬────────────┐" at (1,1).
    print "│compassHeading   │ " + round(compassHeading()):tostring:padleft(10) + "°│" at (1,2).
    print "│inital pitch     │ " + round(initalPitch,1):tostring:padleft(10) + "°│░" at (1,3).
    print "│inital apoasis   │ " + round(initialApoasis):tostring:padleft(10) + "m│░" at (1,4).
    print "│current apoapsis │ " + round(ship:orbit:apoapsis):tostring:padleft(10) + "m│░" at (1,5).
    print "│current periapis │ " + round(ship:orbit:periapsis):tostring:padleft(10) + "m│░" at (1,6).
    print "│target pitch     │ " + round(targetPitch,1):tostring:padleft(10) + "°│░" at (1,7).
    print "└─────────────────┴────────────┘░" at (1,8).
    print "  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░" at (1,9).
}