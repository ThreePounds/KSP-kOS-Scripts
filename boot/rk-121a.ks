//#include "0:/lib/telemetry.ks"
@lazyGlobal off.

local propEngineMod is 0.
local propBlades is 0.

copypath("0:/lib/telemetry","1:/").
runoncepath("telemetry").

startTelemetry().

lock scaledthrottle to min(ship:control:pilotmainthrottle * 133.33, 100).
lock deployAngle to map(ship:control:pilotmainthrottle, 0, 1, 0, 85).
set propEngineMod to ship:partsnamed("RotorEngine.02")[0]:getmodule("ModuleRoboticServoRotor").
set propBlades to ship:partsnamed("mediumPropeller").

local propBladesMods is list().
for propBlade in propBlades {
    propBladesMods:add(propBlade:getmodule("ModuleControlSurface")).
}

until false {
    propEngineMod:setfield("torque limit(%)", scaledthrottle).
    for propBladeMod in propBladesMods {
        propBladeMod:setfield("deploy angle", deployAngle).
    }
    wait 0.
}

local function map {
    parameter x, in_min, in_max, out_min, out_max.
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min.
}

