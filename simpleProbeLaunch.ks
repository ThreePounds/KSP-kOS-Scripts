//#include "lib/debug.ks"
//#include "lib/navigation.ks"
//#include "lib/simpleCountdown.ks"
//#include "lib/telemetry.ks"
@lazyGlobal off.
print "===simpleProbeLaunch=== V1.0.2".

local importList is List(
    "lib/debug.ks",
    "lib/navigation.ks",
    "lib/simpleCountdown.ks"
    // "lib/telemetry.ks",
).

for file in importList {
    copyPath("0:/"+file,"1:/"+file).
    runOncePath(file).
}

local targetApoapsis is 100_000.

local stageDurations is runningSum(list(
    0,
    24,
    116
)).
local stageTime is stageDurations:iterator().
stageTime:next().

wait until ship:unpacked.

simpleCountdown().

if abort {
    //intentionally crash
    print 0/0.
}

lock throttle to 1.
local launchTime is time:seconds.

// time based staging logic
when time:seconds > launchTime + stageTime:value() then {
    stage.
    return stageTime:next().
}

wait until ship:stagenum = 2.
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

unlock targetPitch.
local targetPitch to 0.

until ship:periapsis > 75_000 {
    printDebug().
    wait 0.
}

lock throttle to 0.
print "launch complete.".
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

