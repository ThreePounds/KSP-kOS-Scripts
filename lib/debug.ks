//#include "../init.ks"
@lazyGlobal off.
printToTerminal("===lib/debug=== V0.0.2").

function drawDebugVector {
    parameter vector.
    parameter label is "".
    parameter color is red.
    parameter isVisible is true.

    local drawvector is vecDrawArgs().
    if vector:istype("UserDelegate") {
        set drawvector:vectorupdater to vector.
    } else {
        set drawvector:vector to vector.
    }
    set drawvector:label to label.
    set drawvector:color to color.
    set drawvector:scale to 5.
    set drawvector:width to 0.1.
    set drawvector:show to isVisible.
    return drawvector.
}