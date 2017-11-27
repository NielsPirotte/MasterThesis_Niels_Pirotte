library ieee;
use ieee.std_logic_1164.all;

library work;
use work.constants.all;

entity counter is
   generic(q: integer);
   port(   input: 	in  std_logic_vector(q-1 downto 0);
           output: 	out std_logic_vector(q-1 downto 0)
           );
end counter;

architecture arch_counter of counter is
   
   signal c: std_logic_vector(q-1 downto 0);
   
   component adder
   port(   a, b, c_in: in  std_logic;
           s, c_out:   out std_logic
       );
   end component;
   
begin
	 inst_adder_0: adder
		port map(a(0), '0', '1', output(0), c(0));
		
     	 gen_ab: for i in q-1 downto 1 generate
		inst_adder: adder
			port map(a(i), '0', c(i-1), output(i),  c(i));
         end generate;
   
end arch_counter;
