@lazyGlobal off.

local importlist is list(
    "lv-t05-2-1r-stayputnik.ks"
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

runpath(importlist[0]).