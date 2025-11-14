//#include "init.ks"
//#include "/lib/debug.ks"
@lazyGlobal off.

local guix is 50.
local guiy is 600.

if not exists("init.ks") { copyPath("0:init.ks", "1:"). }
runOncePath("init.ks").

for lib in list(
    "lib/debug.ks"
){ runOncePath(loadScript(lib)). }

local dirStruct is lex(
    "pitch", 0,
    "yaw", 0,
    "roll", 0
).

clearGuis().
clearVecDraws().

lock baseref to lookDirUp(north:vector, up:vector).

lock myrot to R(dirStruct["pitch"], dirStruct["yaw"], dirStruct["roll"]).
lock mydir to baseref * myrot.

local basevec0 is drawDebugVector({return baseref:forevector.},"Base:Fore", yellow, false).
local basevec1 is drawDebugVector({return baseref:topvector.},"Base:Top", cyan, false).
local basevec2 is drawDebugVector({return baseref:starvector.},"Base:Star", magenta, false).
local baseveclex is lex("Fore", basevec0, "Top", basevec1, "Star", basevec2).

local dirvec0 is drawDebugVector({return mydir:forevector.},"Direction:Fore", green, false).
local dirvec1 is drawDebugVector({return mydir:topvector.},"Direction:Top", blue, false).
local dirvec2 is drawDebugVector({return mydir:starvector.},"Direction:Star", red, false).

local labels is lex().
local sliders is lex().
local buttons is lex().
local spacings is list().

local mygui is gui(400).
set mygui:skin:button:width to 100.
// local mygui is mygui:addvlayout().

local dirlex is lex().
dirlex:add("North/Up", {return lookDirUp(north:vector, up:vector).}).
dirlex:add("Up/South", {return lookDirUp(up:vector, -north:vector).}).
dirlex:add("Orbitalcelocity", {return lookDirUp(ship:velocity:orbit, up:vector).}).
dirlex:add("Surfacecelocity", {return lookDirUp(ship:velocity:surface, up:vector).}).
dirlex:add("Raw", {return R(0, 0, 0).}).
dirlex:add("Facing", ship:facing).

local vectordisplaylabel is mygui:addlabel("<b>Display:</b>").
local basevecscheckbox is mygui:addcheckbox("Coordinate vectors", false).
set basevecscheckbox:ontoggle to toggleVecs@:bind(list(basevec0, basevec1, basevec2)).
local rotationveccheckbox is mygui:addcheckbox("Direction vectors", false).
set rotationveccheckbox:ontoggle to toggleVecs@:bind(list(dirvec0, dirvec1, dirvec2)).

spacings:add(mygui:addspacing(15)).
local optionslabel is mygui:addlabel("<b>Base Coordinates:</b>").
local optionshlayout is mygui:addhlayout().
local optionsbox is optionshlayout:addpopupmenu.
local resetfacingbutton is optionshlayout:addbutton("Update facing").
set resetfacingbutton:onclick to resetFacing@.
set optionsbox:options to dirlex:keys().
set optionsbox:index to 0.
set optionsbox:style:width to 170.
displayVectors(optionsbox:value).
set optionsbox:onchange to displayVectors@.

spacings:add(mygui:addspacing(15)).
local axishlayouts is lex().
local axislabel is mygui:addlabel("<b>Rotation:</b>").
for axis in list("roll", "pitch", "yaw"){
    labels:add(axis, mygui:addlabel(axis + ": " + dirStruct[axis])).
    axishlayouts:add(axis, mygui:addhlayout()).
    sliders:add(axis, axishlayouts[axis]:addhslider(0, -180, 180)).
    buttons:add(axis, axishlayouts[axis]:addbutton("reset")).
    spacings:add(mygui:addspacing(15)).
    set sliders[axis]:onchange to updateLex@:bind(dirStruct, axis).
    set buttons[axis]:onclick to resetAxis@:bind(axis).
    set buttons[axis]:style:width to 50.
}
set labels["roll"]:style:textcolor to yellow.
set labels["pitch"]:style:textcolor to magenta.
set labels["yaw"]:style:textcolor to cyan.
local printhlayout is mygui:addhlayout().
local printResultButton to printhlayout:addbutton("Print Rotation").
set printResultButton:onclick to {printToTerminal(myrot).}.
local printRawButton to printhlayout:addbutton("Print Raw").
set printRawButton:onclick to {printToTerminal(mydir).}.

set mygui:x to guix.
set mygui:y to guiy.
// set mygui:skin:font to guifont.

mygui:show().

lock steering to mydir.

until false {
    wait 0.
}

function resetFacing {
    set dirlex["Facing"] to ship:facing.    
}

function toggleVecs {
    parameter veclist.
    parameter value.
    for vec in veclist{
        set vec:show to value.
    }
}

function displayVectors {
    parameter inputString.
    if dirlex[inputString]:istype("UserDelegate") {
        lock baseref to dirlex[inputString]:call.
    } else {
        lock baseref to dirlex[inputString].
    }
    for word in list("Fore", "Top", "Star") {
        set baseveclex[word]:label to inputString + ":" + word.
    }
}

function updateLex {
    parameter inputLex.
    parameter key.
    parameter rawvalue.
    local value is round(rawvalue).
    set inputLex[key] to value.
    set labels[key]:text to key + ": " + value.
}

function resetAxis {
    parameter axis.
    set sliders[axis]:value to 0.
}
