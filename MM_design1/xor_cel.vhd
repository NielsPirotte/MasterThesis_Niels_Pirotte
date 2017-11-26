----------------------------------------------------------------------
-- Author: Niels Pirotte
--
-- Project Name: Masterthesis Niels Pirotte
-- Module Name: xor_cell
-- Description: bit*word operation
-- Description: For xor operation of 1 bit of x_i with word y and
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.constants.all;

entity xor_cell is
   generic(q: integer);
   port(   b:      in  std_logic_vector(q-1 downto 0);
           a_i:    in  std_logic;
           output: out std_logic_vector(q-1 downto 0)
   );
end xor_cell;

architecture arch_xor_cell of xor_cell is
   
begin   
   gen_ab: for i in q-1 downto 0 generate
      output(i) <= a_i xor b(i);
   end generate;    
   
end arch_xor_cell;
