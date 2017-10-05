--for multiplication of 1 bit of x_i with y and
--for multiplication of 
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.constants.all;

entity cell is
   generic(d: integer);
   
   port(   b: in std_logic_vector(d-1 downto 0);
           a_i: in std_logic;
           output: out std_logic_vector(d-1 downto 0)
           );
end cell;

architecture arch_cell of cell is
   
begin
	gen_ab: for i in d-1 downto 0 generate
        output(i) <= a_i and b(i);
        end generate; 
end arch_cell;
