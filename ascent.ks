//#include "init.ks"
//#include "lib/equipment.ks"
@lazyGlobal off.
printToTerminal("===ascent=== V0.0.0").

printToTerminal("Locking steering to straight up.").
lock steering to lookDirUp(up:forevector, up:topvector).

printToTerminal("Waiting for airspeed to build.").
wait until ship:verticalspeed > 200.