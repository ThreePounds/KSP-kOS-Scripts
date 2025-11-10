//#include "init.ks"
@lazyGlobal off.
printToTerminal("===simpleCountdown=== V0.0.1").

global function simpleCountdown {
    parameter countDownDuration is 10.
    printToTerminal(
        "Launch control and guidance for",
        ship:name,
        "Press [1] to start launch sequence.",
        "Press [Abort] at any time to stop launch sequence"
    ).

    wait until getSingleInput() = "1".
 
    printToTerminal("Launch Sequence started", "Launching in: " + countDownDuration + " seconds.").

    for countDown in range(countDownDuration,-1) {
        wait 1.
        if abort {
            printToTerminal(centerHudText("Launch aborted!", 5, red)).
            return 1.
        }
        centerHudText("T-00:00:" + countDown:tostring:padleft(2):replace(" ","0")).
        if countDown = 0 {
            wait 1.
            printToTerminal(centerHudText("Launch!",5)).
        }
    }
}

local function getSingleInput {
    until false {
        if terminal:input:haschar {
            return terminal:input:getchar().      
        }
    wait 0.
    }

}

local function centerHudText {
    parameter string.
    parameter delay is 1.4.
    parameter colour is green.
    local size is 40.
    local upper_center is 2.
    hudtext(
        string,
        delay,
        upper_center,
        size,
        colour,
        false
    ).
    return string.
}