library ieee;
use ieee.std_logic_1164.all;

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

--number of bits of a dataword w(word) with w>d and d|w
--Het datawoord moet een veelvoud zijn van de hoeveelheid digits die tegelijkertijd worden verwerkt.
constant w: std_logic_vector(3 downto 0):= "0100"; --4

--number of bits of the datapath d(digits)
constant d: integer := 4; --Zou dit werken?? wrs een te grote implementatie 32bit per int

--EC (Elliptic Curve)

end constants;  