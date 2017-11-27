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

library work;
use work.constants.all;
   generic(log2primeM: integer := 4; 
	   e:          integer := 3
          );

entity MMALU is
   port(   rst, clk: in   std_logic;
           load:     in   std_logic;
           x:        in   std_logic_vector(log2primeM+1 downto 0);
           y:        in   std_logic_vector(log2primeM+1 downto 0);
           en:       in   std_logic;
           t:        out  std_logic_vector(log2primeM+1 downto 0);
           done:     out  std_logic); 
end MMALU;

architecture arch_MMALU of MMALU is
   subtype counter:     std_logic_vector(e downto 0);

  --Registers
   signal regX: 	std_logic_vector(log2primeM+1 downto 0);
   signal regY: 	std_logic_vector(log2primeM+1 downto 0);
   signal regT: 	std_logic_vector(log2primeM downto 0);
   signal X_i, Y_j:     std_logic;
   signal s_prev:	std_logic;
   signal cntr_0:       counter;
   signal cntr_0_next:  counter;
   signal cntr_1:       counter;
   signal cntr_1_next:  counter;
   signal shift_i:	std_logic;
   signal shift_j:      std_logic;
   signal u: 		std_logic;
   
   component cell
      port(   s_prev:     in  std_logic;
              Xi_Yj:      in  std_logic;
              u_Mj:       in  std_logic;
              write_out2: in  std_logic:
              clk, rst:   in  std_logic;
              out1:       out std_logic;
              out2:       out std_logic
          );
   end component;

   component RCadder
      generic(q: integer);
      port(   input:  in  std_logic_vector(q-1 downto 0);  
	      output: out std_logic_vector(q-1 downto 0)
          );
   end component;

begin
   -- Counter
   counter_adder_0: counter
      generic map(e+1);
      port map( input => cntr_0;
		output => cntr_0_next
              );
  
    counter_adder_1: counter
      generic map(e+1);
      port map( input => cntr_1;
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
   end
	
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

   X_i <= regX(0);
   
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
   
   Y_j <= regY(0);

   reg_t: process(rst, clk)
   begin
      if clk'event and clk = '1' then
         if rst = '0' then
            regT <= (others => '0');
         elsif load = '1' then 
            regT <= (others => '0');
         elsif en = '1' then
            regT <= Tnext srl d; -- with div d 
         else
            regT <= regT;
         end if;
      end if;
   end process;
   
   --> Algorithm voor d = 1 (per bit)
   -- u := t0 = {regT[0] + regX[0]*regY[0]} (-m0^(-1) -->1) mod 2
   -- Tnext <= {regT + --regX[0]*regY-- + --u*primeM-- } >> d
   
   u <= regT(0) xor (regX(0) and regY(0));
   
   inst_cell_0: cell
      generic map(log2primeM+2)
      port map(	s_prev => s_prev,
                Xi_Yj =>    
                u_Mj =>
                write_out2 => 
                clk => clk,
		rst => rst,
                out1 =>  
                out2 =>
	       );
end arch_MMALU;
