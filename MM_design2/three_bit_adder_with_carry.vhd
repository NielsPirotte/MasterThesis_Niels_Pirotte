----------------------------------------------------------------------
-- Author: Niels Pirotte
--
-- Project Name: Masterthesis Niels Pirotte
-- Module Name: 3_bit_adder_with_carry
-- Description: Adder functionality for adding 3 bits and a carry of 2 bits. This carry is always bounded to 2 bits.
-- This can be derived as in my Master's thesis in the section about scalable MM designs 
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.constants.all;

entity three_bit_adder_with_carry is
   port(   in_0, in_1, in_2: in  std_logic;
   	   c_in:	     in  std_logic_vector(1 downto 0);
           s:		     out std_logic;
           c_out:	     out std_logic_vector(1 downto 0)
           );
end three_bit_adder_with_carry;

architecture arch_adder of three_bit_adder_with_carry is
signal c_temp: std_logic;

component adder
   port(   a, b, c_in: in  std_logic;
           s, c_out:   out std_logic
       );
   end component;
   
begin
     inst_adder_0: adder
		port map(
			a => in_0,
			b => in_1, 
			c_in => in_2,
			s => s,
			c_out => c_temp
			);
     inst_adder_1: adder
		port map(
			a => c_temp,
			b => c_in(0), 
			c_in => c_in(1),
			s => c_out(0),
			c_out => c_out(1)
			);	
end arch_adder;
