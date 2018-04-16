----------------------------------------------------------------------
-- Author: Niels Pirotte
--
-- Project Name: Masterthesis Niels Pirotte
-- Package Name: constants
-- Description: Definition and settings of parameters ECC coprocessor
-- Information:
-- This implementation provides a ECC (Elliptic Curve Crypto) hardware implementation for an ASIC
-- We use the complete addition formulas for prime order elliptic curves as described by: Complete Addition Formulas for Prime Order Elliptic Curves by Joost Renes, Craig Costello, and Lejla Batina
-- Thereby reducing potential vulnerabilities (No distinction between doubling and addition). This is accomplished by defining a complete addition law on an Edwards EC
-- The goal is an implementation optimizing the area of the ASIC

-- Note:
-- This file is specifically for use with the scalable design instead of the full scale design
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- To determine number of bits for an integer
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

package constants is
-- Parameters
--
-- Number of bits of the prime
constant log2primeM: integer := 3;
--constant log2primeM: integer := 256;

-- Therefore the inputs of the MMALU are < 2N
-- Number of bits of scanning counter for the 2N inputs
constant e: integer := integer(ceil(log2(Real(log2primeM+4))));

-- Because the word size equals '1', The word counter equals the Montgomery counter 
------------------------------------------------------------------
--Defining the prime field

constant primeM: std_logic_vector(log2primeM-1 downto 0) := "111"; -- 7
--For the secp256k1 curve
--constant primeM: std_logic_vector(log2primeM-1 downto 0) := x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F";

------------------------------------------------------------------
--EC (Elliptic Curve)
--defining the EC
------------------------------------------------------------------
--i.e. R = 128 = 2 mod 7 and b = 1 => 3*2*2 = 12 mod 7 = 5 mod 7
-->It is crucial b3 is given in Montgomery coordinates!!!
constant B3: std_logic_vector(log2primeM-1 downto 0) := "101";
--constant B3: std_logic_vector(log2primeM-1 downto 0) := x"0000000000000000000000000000000000000000000000000000015000050250";
end constants;  
