@lazyGlobal off.
print "===lib/debug=== V0.0.1".

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