//#include "lib/debug.ks"
//#include "lib/navigation.ks"
//#include "lib/simpleCountdown.ks"
//#include "lib/telemetry.ks"
@lazyGlobal off.
print "===launch=development=== V0.0.1".

local importList is List(
    // "lib/debug.ks",
    "lib/navigation.ks",
    // "lib/simpleCountdown.ks",
    "lib/telemetry.ks"
).

for file in importList {
    copyPath("0:/"+file,"1:/"+file).
    runOncePath(file).
}

local myconfiguration is telemetryConfiguration().

local myFailureModule is ship:partsnamed("UKSliquidEngineLVT05")[0]:getmodule("TestFlightFailure_IgnitionFail"). // todo

myconfiguration:addSensor(
    "ignition penalty for q",
    {return myFailureModule:getField("ignition penalty for q").}  
).

myconfiguration:addSensor("q", {return ship:q * constant:ATMtokPa.}).

startTelemetry(path("0:/log"),myconfiguration).

until false {
    wait 0.
}
