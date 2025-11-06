@lazyGlobal off.
print "===vectorTest=== V0.0.4".

clearVecDraws().

local targetApoapsis is 85000.

lock surfVelHeadingVec to vxcl(up:forevector, ship:velocity:surface).
lock surfVelHeadingDir to lookDirUp(surfVelHeadingVec, up:forevector).
local initalPitch is vAxisAng(
    ship:velocity:surface:normalized,
    -up:forevector,
    surfVelHeadingVec
    
).
local initialApoasis is ship:orbit:apoapsis.
// lerp pitch to 0 when ship:apoapsis = targetApopsis
lock targetPitch to (initalPitch * (targetApoapsis - ship:orbit:apoapsis)) / (targetApoapsis - initialApoasis). 
lock targetDir to surfVelHeadingDir * R(targetPitch,0,0).

lock steering to targetDir.

print "compassHeading: ".
print "inital pitch:   " + round(initalPitch,1). 
print "inital apoasis: " + round(initialApoasis).
print "target pitch:   ".
until false {
    print round(compassHeading()):tostring:padleft(3):replace(" ","0") + "°" at (16,6).
    print round(targetPitch,1) at (16,9).
    wait 0.
}

function drawUpdateVector {
    parameter vector.
    parameter label is "".
    parameter color is red.

    local drawvector is vecDrawArgs().
    set drawvector:vectorupdater to vector.
    set drawvector:label to label.
    set drawvector:color to color.
    set drawvector:scale to 5.
    set drawvector:width to 0.1.
    set drawvector:show to true.
    return drawvector.
}

function drawSimpleVector {
    parameter vector.
    parameter label is "".
    parameter color is red.

    local drawvector is vecDrawArgs().
    set drawvector:vector to vector.
    set drawvector:label to label.
    set drawvector:color to color.
    set drawvector:scale to 5.
    set drawvector:width to 0.1.
    set drawvector:show to true.
    return drawvector.
}

function vAxisAng {
    parameter vector.
    parameter axisy. // angle is positive in this direction
    parameter axisx. // axis this angle is relative to
    local trig_y is vDot(axisy, vector).
    local trig_x is vDot(axisx, vector).
    return arcTan(trig_y, trig_x).
}

function compassHeading {
    local rawHeading is vAxisAng(
        ship:facing:forevector,
        -up:starvector, // = east
        north:forevector
    ).
    if rawHeading > 0 {
        return rawHeading.
    } else {
        return 360 + rawHeading.
    }
}

