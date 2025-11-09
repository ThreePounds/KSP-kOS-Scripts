//#include "init.ks"
//#include "lib/navigation.ks"
//#include "lib/simpleCountdown.ks"
//#include "lib/telemetry.ks"
@lazyGlobal off.

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

local scienceModList is list().
for partName in list("sensorThermometer", "sensorBarometer") {
    for part in ship:partsnamed(PartName) {
        scienceModList:add(part:getmodule("ModuleScienceExperiment")).
        printToTerminal("Experiment added: " + part:title).
    }
}

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

until ship:stagenum = initialStage - 3 {
    printDebug().
    wait 0.
}
printToTerminal("Terminating guided ascent").
lock throttle to 0.
unlock steering.
unlock throttle.

wait until ship:verticalspeed < 0.
for experiment in scienceModList {
    experiment:deploy.
    printToTerminal("Deploying " + experiment:part:title).
}

printToTerminal("Script complete. Goodbye").

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