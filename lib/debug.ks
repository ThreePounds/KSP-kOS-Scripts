@lazyGlobal off.
print "===lib/debug=== V0.0.1".

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