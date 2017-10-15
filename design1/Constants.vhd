library ieee;
use ieee.std_logic_1164.all;
--For determining the number of bits needed for a integer
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

package constants is
--Information on the app:
--This implementation provides a ECC (Elliptic Curve Crypto) hardware implementation for an ASIC
--We use the complete addition formulas for prime order elliptic curves as described by [1] --> thereby reducing potential vulnerabilities (No distinction between doubling and addition). This is accomplished by defining a complete addition law on a edwards EC
--The goal is an implementation optimizing the area of the ASIC

  
--General parameters for the MALU
----------------------------------

--The MALU consists of a datapath and a control path
--For the MALU we implement a Montgommery multiplicator and an adder (controlled by cmd).
--constant primeM: std_logic_vector(3 downto 0) := "1101"; -- 13
constant primeM: std_logic_vector(3 downto 0) := "0111"; -- 7

--number of bits of the datapath d(digits)
constant d: integer := 4; --Zou dit werken?? wrs een te grote implementatie 32bit per int

--number of words (designed to be a multiple of 2)
constant e: integer := ceil(log2(real(d+1)));

--EC (Elliptic Curve)

end constants;  
