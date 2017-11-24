----------------------------------------------------------------------------------
-- ECC School - Hardware Tutorial 
-- Nijmegen, November 9-11, 2017 
-- 
-- Authors: Nele Mentens and Tim Güneysu
--  
-- Project Name: ECCcore
-- Module Name: addsubn
-- Description: n-bit adder/subtracter
----------------------------------------------------------------------------------

-- include the STD_LOGIC_1164 package in the IEEE library for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- include the STD_LOGIC_UNSIGNED package for arithmetic operations
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- describe the interface of the module
-- if as = '0': sum = a + b
-- if as = '1': sum = a - b 
entity addsubn is
    generic(n: integer := 8);
    port(   a, b: in std_logic_vector(n-1 downto 0);
            as: in std_logic;
            sum: out std_logic_vector(n-1 downto 0));
end addsubn;

-- describe the behavior of the module in the architecture
architecture behavioral of addsubn is

    -- declare internal signals
	signal as_vec, b_as: std_logic_vector(n-1 downto 0);

begin

    -- assign as to each bit of as_vec
    as_vec <= (others => as);
    
    -- perform a bitwise XOR of b and as_vec
    -- if as = '0': b_as = b
    -- if as = '1': b_as = not(b)
    b_as <= b xor as_vec;
    
    -- add a to b or not(b)
    -- if as = '1': add 1 to the sum
    sum <= a + b_as + as;

end behavioral;