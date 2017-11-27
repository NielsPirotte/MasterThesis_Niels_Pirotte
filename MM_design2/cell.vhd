----------------------------------------------------------------------
-- Author: Niels Pirotte
--
-- Project Name: Masterthesis Niels Pirotte
-- Module Name: cell
-- Description: This cell forms the main datapath of the MM
-- as drawn in design model nr 1??
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.constants.all;

entity cell is
   port(   s_prev:     in  std_logic;
           Xi_Yj:      in  std_logic;
	   u_Mj:       in  std_logic;
	   write_out2: in  std_logic:
	   clk, rst:   in  std_logic;
           out1:       out std_logic;
	   out2:       out std_logic
           );
end cell;

architecture arch_cell of cell is
   component csa
	port( a, b, c_in: in  std_logic;
	      s, c_out:   out std_logic
	);
   end component;

   signal u0, u1:    std_logic;
   signal t0, t1:    std_logic;
   signal reg_c:     std_logic;

begin

   out2 <= write_out2 and reg_c;

   register1: process(clk, rst)
   begin
	if clk'event and clk = '1' then
	   if rst = '0' then 
		reg_c <= '0';
	   else
	        reg_c <= u1;
	   end if
	end if; 
   end process;

   csa_T: csa
	port map(a => reg_c;
		 b => s_prev;
		 c_in => Xi_Yj;
		 s => t0;
		 c_out => t1
		);

  csa_U: csa
	port map(a => t0;
		 b => u_Mj;
		 c_in => t1;
		 s => out1;
		 c_out => c;
	);

end arch_cell;
