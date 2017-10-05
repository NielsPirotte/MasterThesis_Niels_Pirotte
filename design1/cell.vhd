--for multiplication of 1 bit of x_i with y and
--for multiplication of 
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.constants.all;

entity cell is
   generic(d: integer;
           q: integer);
   port(   b: in std_logic_vector(q-1+d downto 0);
           a_i: in std_logic;
           output: out std_logic_vector(q-1+d downto 0)
           );
end cell;

architecture arch_cell of cell is
   
begin
   
   gen_d1: if d=1 generate
   
      gen_ab: for i in q+d-1 downto 0 generate
         output(i) <= a_i and b(i);
      end generate;
   
   end generate;      
   
--   gen_dnot1: if d>1 generate
--
--      gen_ab: for i in q-1 downto 0 generate
--         ab(i) <= a_i and b(i);
--      end generate;
--   
--      gen_mp: for i in q-1 downto 0 generate
--         tp(i) <= t(q-1+d) and p(i) and cmd;
--      end generate;
--   
--      gen_abt: for i in q-1 downto 0 generate
--         abt(i) <= ab(i) xor t(i-1+d);
--      end generate;
--   
--      gen_t_next: for i in q-1 downto 0 generate
--         t_next(i-1+d) <= abt(i) xor tp(i);
--      end generate;
--      
--      t_next(d-2 downto 0) <= t(d-2 downto 0);
--      
--   end generate;      
--   
end arch_cell;