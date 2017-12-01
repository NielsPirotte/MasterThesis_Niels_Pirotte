# MasterThesis_Niels_Pirotte
VHDL design of ASIC implementation for ECC with complete formulae

## General

### MM_design1
First implementation of Montgomery Multiplication with 4N outputs and 2N outputs.
Also 2 2N inputs can be added and subtracted resulting in a 4N output

### MM_design2
Implementation according to the paper of Koç: "A scalable Architecture for Montgomery Multiplier"

### PA_design1
Implementation of Point Addition with complete formulae according to: "Complete addition formulas for prime order elliptic curves" p13 algorithm 8

### PM_design1
Implementation of point multiplication using the principle of the Montgomery Ladder

## TODO

###In progress

####1

Implement Statemachine

####2 -- done, not possible (recheck after first implementation)

Bekijk doorschuifmechanisme voor Multiplexers

####3 -- Implemented, but not tested

Implement scalable architecture --> Koc

####4

Optimalization

###Completed

Implement non-modular subtraction and addition

Implement point multiplication module

Counter adders can be more efficient (counter.vhd)
