library ieee;
use ieee.std_logic_1164.all;

library work;
use work.constants.all;

entity RCadder is
   generic(d: integer);
   
   port(   a: 		in  std_logic_vector(d-1 downto 0);
           b: 		in  std_logic_vector(d-1 downto 0);
           c_in: 	in  std_logic;
           c_out:	out std_logic;
           output: 	out std_logic_vector(d-1 downto 0)
   );
end RCadder;

architecture arch_RCadder of RCadder is
   
   signal c: std_logic_vector(d-1 downto 0);
   
   component adder
   generic(d: integer;
           q: integer);
   port(   a, b, c_in: in std_logic;
           s, c_out: out std_logic
           );
   end component;
   
begin
	-- generation of a 
	c_out <= c(d-1);

	inst_adder_0: adder
		generic map(d, q)
		port map(a(0), b(0), c_in, output(0), c(0));
		
     	gen_ab: for i in d-1 downto 1 generate
		 inst_adder: adder
			generic map(d, q)
			port map(a(i), b(i), c(i-1), output(i),  c(i));
      end generate;
   
end arch_RCadder;
