@lazyGlobal off.

clearGuis().
local mygui is gui(500).
set mygui:skin:font to "Consolas Bold".

local myhlayout is mygui:addhlayout().
local myvlayout is myhlayout:addvlayout().



local mylabellist is list().

for line in list("name", "altitude", "periapsis", "speed", "whatever") {
    mylabellist:add(myvlayout:addlabel(line)).
}

local myslider is myvlayout:addhslider(50,0,100).
set myslider:style:hstretch to true.

local mybutton is myhlayout:addcheckbox("show debug vectors").

for label in mylabellist {
    set label:style:hstretch to true.
    set label:style:align to "left".
}

mygui:show().

until false { wait 0. }
