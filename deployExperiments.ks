//#include "init.ks"
@lazyGlobal off.

local antennaList is ship:partsnamed("longAntenna").

printToTerminal("Deploying Antennas:").
for antenna in antennaList {
    deployAntenna(antenna).
}
printToTerminal("Deploying Complete.").
printToTerminal("Hiberating Core.").
core:part:getmodule("ModuleCommand"):setfield("hibernation", true).
printToTerminal("Running Experiment.").
runExperiments().
printToTerminal("Sleeping until homeconnection is restored.").
wait until homeConnection:isconnected.
transmitExperiments().


function deployAntenna {
    parameter deployPart.
    local deployMod is deployPart:getmodule("ModuleDeployableAntenna").
    printToTerminal("Extending: " + deployPart:title).
    if deployMod:alleventnames:find("extend Antenna") >= 0 { 
        deployMod:doevent("extend antenna").
    } else {
        printToTerminal("Can't extend Antenna.").
    }
}

function runExperiments {
    local scienceModList is ship:modulesnamed("ModuleScienceExperiment").
    for scienceMod in scienceModList {
        scienceMod:deploy().
        printToTerminal("Deploying: " + scienceMod:part:title).
    }
}

function transmitExperiments {
    local scienceModList is ship:modulesnamed("ModuleScienceExperiment").
    for scienceMod in scienceModList {
        if scienceMod:hasdata {
            scienceMod:transmit().
            printToTerminal("Transmission started:").
            printToTerminal(scienceMod:part:title).
        }
    }
}