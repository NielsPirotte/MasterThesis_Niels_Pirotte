library ieee;
use ieee.std_logic_1164.all;

library work;
use work.constants.all;

entity rca is
   port(   a, b, c_in: in  std_logic;
           s, c_out:   out std_logic
       );
end rca;

architecture arch_rca of rca is
   
begin
     s <= a xor b xor c_in;
     c_out <= (a and b) or (c_in and (a or b));
end arch_rca;
