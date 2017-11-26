library ieee;
use ieee.std_logic_1164.all;

library work;
use work.constants.all;

entity adder is
   port(   a, b, c_in: in std_logic;
           s, c_out: out std_logic
           );
end adder;

architecture arch_adder of adder is
   
begin
     s <= a xor b xor c_in;
     c_out <= (a and b) or (c_in and (a or b));
end arch_adder;
