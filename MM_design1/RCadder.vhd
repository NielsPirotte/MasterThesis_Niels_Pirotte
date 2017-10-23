library ieee;
use ieee.std_logic_1164.all;

library work;
use work.constants.all;

entity RCadder is
   generic(q: integer);
   port(   a: 		in  std_logic_vector(q downto 0);
           b: 		in  std_logic_vector(q downto 0);
           output: 	out std_logic_vector(q downto 0)
           );
end RCadder;

architecture arch_RCadder of RCadder is
   
   signal c: std_logic_vector(q downto 0);
   
   component adder
   port(   a, b, c_in: in  std_logic;
           s, c_out:   out std_logic
       );
   end component;
   
begin
	 inst_adder_0: adder
		port map(a(0), b(0), '0', output(0), c(0));
		
     	 gen_ab: for i in q downto 1 generate
		inst_adder: adder
			port map(a(i), b(i), c(i-1), output(i),  c(i));
         end generate;
   
end arch_RCadder;
