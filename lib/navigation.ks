@lazyGlobal off.
printToTerminal("===lib/navigation=== V0.0.1").

function vAxisAng {
    parameter vector.
    parameter axisy. // angle is positive in this direction
    parameter axisx. // axis this angle is relative to
    local trig_y is vDot(axisy, vector).
    local trig_x is vDot(axisx, vector).
    return arcTan2(trig_y, trig_x).
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