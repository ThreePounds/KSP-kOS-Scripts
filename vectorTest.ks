@lazyGlobal off.
print "===vectorTest=== V0.0.4".

clearVecDraws().

local myvec0 is drawUpdateVector({return ship:facing:forevector.},"ship:facing",red).
local myvec1 is drawUpdateVector({return north:forevector.},"north",blue).


lock headingVector to vxcl(up:forevector,ship:facing:forevector).

local myvec2 is drawUpdateVector({return headingVector.},"heading",green).

function compassHeading {
    local eastVec is vcrs(up:forevector,north:forevector).
    local headingVec is vxcl(up:forevector,ship:facing:forevector).
    local trig_x is vDot(eastVec, headingVec).
    local trig_y is vDot(north:forevector, headingVec).
    local rawHeading is arcTan2(trig_x, trig_y).
    if rawHeading > 0 {
        return rawHeading.
    } else {
        return 360 + rawHeading.
    }
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

print "compassHeading:".
until false {
    print round(compassHeading()):tostring:padleft(3):replace(" ","0") + "°" at (16,6).
    wait 0.
}