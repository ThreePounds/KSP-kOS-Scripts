@lazyGlobal off.

local targetApoapsis is 100_000.
local stageDurationList is List(
    0,
    35, // wait until ship:q < 5 kPA
    116
).

local importlist is list(
    "simpleProbeSubOrbitalLaunch.ks"
).

local filelist is list().

list files in filelist.
for file in filelist {
    if not (file = "boot") {
        deletePath(file).
    }
}

for file in importlist {
    copyPath("0:/" + file, "1:/" + file).
}

runpath(importlist[0],
    targetApoapsis,
    stageDurationList
).