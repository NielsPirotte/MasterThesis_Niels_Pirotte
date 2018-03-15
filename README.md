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

Remark: The implementation is working properly, but keep in mind that x2 and y2 need to be converted to the montgomery domain. They are the only inputs that need to be converted.

Also the done signal of point_addition.vhd needs to be corrected.

### PA_design2
Implementation of Point Addition with complete formulae according to: "Complete addition formulas for prime order elliptic curves" p12 algorithm 7

Uses the same number of registers design 1.

### PM_design1
Implementation of point multiplication using the principle of the Montgomery Ladder.

Although no Montgomery ladder would be faster --> only one points needs to be loaded.

## TODO

### 1 Point multiplication

Testing.... COMPLETED! coprocessor is fully functional.

Testbench point multiplication implements secp256k1 curve.

### 2 shiftmechanism for multiplexers
python testprograms were written to check possibility.

outcome: 
  - not possible for algo7(recheck after first implementation);
  - for algo8 2 registers could be entangled, resulting in only 8 write registers.

### 3 Implement scalable architecture --> Koc

Implemented, but not yet tested.

### 4 Optimalization



