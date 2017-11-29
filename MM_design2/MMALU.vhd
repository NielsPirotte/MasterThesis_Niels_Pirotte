----------------------------------------------------------------------
-- Author: Niels Pirotte
--
-- Project Name: Masterthesis Niels Pirotte
-- Module Name: MMALU
-- Description: Modular Montgomery Multiplier using the method of Koç
-- in the paper: "A scalable Architecture for Montgomery Multiplier"
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.constants.all;

entity MMALU is
   generic(log2primeM: integer := 4; 
	   e:          integer := 3
          );

   port(   rst, clk: in   std_logic;
           load:     in   std_logic;
           x:        in   std_logic_vector(log2primeM+1 downto 0);
           y:        in   std_logic_vector(log2primeM+1 downto 0);
           en:       in   std_logic;
           t:        out  std_logic_vector(log2primeM+1 downto 0);
           done:     out  std_logic
       ); 
end MMALU;

architecture arch_MMALU of MMALU is
   subtype cntr_type is std_logic_vector(e downto 0);

  --Registers
   signal regX: 	std_logic_vector(log2primeM+1 downto 0);
   signal regY: 	std_logic_vector(log2primeM+1 downto 0);
   signal regT: 	std_logic_vector(log2primeM downto 0);
   signal Xi_Yj:        std_logic;
   signal u_Mj:         std_logic;
   signal s_prev:	std_logic;
   signal out1, out2:   std_logic;
   signal cntr_0:       cntr_type;
   signal cntr_0_next:  cntr_type;
   signal cntr_1:       cntr_type;
   signal cntr_1_next:  cntr_type;
   signal shift_i:	std_logic;
   signal shift_j:      std_logic;
   signal u: 		std_logic;

   --test
   signal write_out2:   std_logic;
   
   component cell
      port(   s_prev:     in  std_logic;
              Xi_Yj:      in  std_logic;
              u_Mj:       in  std_logic;
              write_out2: in  std_logic;
              clk, rst:   in  std_logic;
              out1:       out std_logic;
              out2:       out std_logic
          );
   end component;

   component counter
      generic(q: integer);
      port(   input:  in  std_logic_vector(q-1 downto 0);  
	      output: out std_logic_vector(q-1 downto 0)
          );
   end component;

begin
   -- Counter
   counter_adder_0: counter
      generic map(e+1)
      port map( input => cntr_0,
		output => cntr_0_next
              );
  
    counter_adder_1: counter
      generic map(e+1)
      port map( input => cntr_1,
		output => cntr_1_next
              );
   
   reg_cntr: process(rst, clk)
   begin
      done <= '0'; shift_j <= '0';
      if clk'event and clk = '1' then
      	if rst = '0' then
      	   cntr_0 <= (others => '0');
	   cntr_1 <= (others => '0');
      	elsif en = '1' then
	    if cntr_0 = e+1 then
		cntr_0 <= (others => '0');
		if cntr_1 = e+1 then
		   done <= '1';
 		   cntr_1 <= (others => '0');
	        else
		   cntr_1 <= cntr_1_next;
		   shift_j <= '1';
		end if;
	     else
		cntr_0 <= cntr_0_next;
	     end if;
	end if;
      end if;	    	
   end process;
	
   -- Because every clockcycle one bit is processed
   shift_i <= en;

   -- Registers
   
   reg_x: process(rst, clk)
   begin
      if clk'event and clk = '1' then
         if rst = '0' then
            regX <= (others => '0');
         elsif load = '1'then
            regX <= x;
         elsif en = '1' then
            regX <= '0' & regX(log2primeM+1 downto 1);
         else
            regX <= regX;
         end if;
      end if;
   end process;
   
   reg_y: process(rst, clk)
   begin
      if clk'event and clk = '1' then
         if rst = '0' then
            regY <= (others => '0');
         elsif load = '1' then
            regY <= y;
         elsif en = '1' then
            --circular shift register shift per word
            regY <= regY(0) & regY(log2primeM+1 downto 1);
         else
            regY <= regY;
         end if;
      end if;
   end process;
   
   Xi_Yj <= regX(0) and regY(0);

   reg_t: process(rst, clk)
   begin
      if clk'event and clk = '1' then
         if rst = '0' then
            regT <= (others => '0');
         elsif load = '1' then 
            regT <= (others => '0');
         elsif en = '1' then
            regT <=  out1 & regT(log2primeM+1 downto 1); 
         else
            regT <= regT;
         end if;
      end if;
   end process;

   s_prev <= regT(0);
   
   --> Algorithm voor d = 1 (per bit)
   -- u := t0 = {regT[0] + regX[0]*regY[0]} (-m0^(-1) -->1) mod 2
   -- Tnext <= {regT + --regX[0]*regY-- + --u*primeM-- } >> d
   
   -- Moet nog worden aangepast
   u <= regT(0) xor (regX(0) and regY(0));
   u_Mj <= u and primeM(to_integer(unsigned(cntr_1)));

--   process (cntr_1, u)
--   begin
--	u_Mj <= '0';
--	for i in 0 to log2primeM+1 loop
--		if (i = cntr_1) then
--			u_Mj <= primeM(i) and u;
--		end if;
--	end loop;
--    end process;

   inst_cell_0: cell
      generic map(log2primeM+2)
      port map(	s_prev => s_prev,
                Xi_Yj => Xi_Yj,   
                u_Mj => u_Mj,
                write_out2 => write_out2,
                clk => clk,
		rst => rst,
                out1 => out1, 
                out2 => out2
	       );
end arch_MMALU;
