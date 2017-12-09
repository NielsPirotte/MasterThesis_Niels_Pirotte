# MasterThesis_Niels_Pirotte
VHDL design of ASIC implementation for ECC with complete formulae

## General
The design uses an active low reset

### MM_design1
First implementation of Montgomery Multiplication with 2 4N inputs and a 2N output.
Also 2 2N inputs can be added and subtracted resulting in a 4N output

### MM_design2
Implementation according to the paper of Koç: "A scalable Architecture for Montgomery Multiplier"

### PA_design1
Implementation of Point Addition with complete formulae according to: "Complete addition formulas for prime order elliptic curves" p13 algorithm 8

### PM_design1
Implementation of point multiplication using the principle of the Montgomery Ladder

## TODO

### In progress

#### 1 -- Implemented, but not tested

Implement Point Addition

#### 2 -- done, not possible (recheck after first implementation)

Look at shiftmechanism for multiplexers

#### 3 -- Implemented, but not tested

Implement scalable architecture --> Koc

#### 4

Optimalization

### Completed

Implement non-modular subtraction and addition

Implement point multiplication module

Counter adders can be more efficient (counter.vhd)
