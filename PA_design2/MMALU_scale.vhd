----------------------------------------------------------------------
-- Author: Niels Pirotte
--
-- Project Name: Masterthesis Niels Pirotte
-- Module Name: MMALU
-- Description: Montgomery multiplier/ adder and subtractor Modular ALU
-- Remark 1: When subtracting automatically 2M is added
-- Remark 2: cmd signal for enabling adding/subtracting
-- Remark 3: Set sub to enable subtracting
-- Remark 4: When loading also always do a rst

-- General remark:
-- A bound is set to the montgomery multiplier: 16M < R.
-- This makes sure x,y < 4N results in t < 2N
-- Therefore a modular add/sub is not needed
-- This means the datapath of the MMALU is 2 bits larger than the number of bits of M
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.constants.all;

entity MMALU is
   -- The datapath is 2 bits larger than log2primeM
   -- The inputs and outputs are only 1 bit larger than log2primeM
   port(   rst, clk: 	in  std_logic;
           load: 	in  std_logic;
           x: 		in  std_logic_vector(log2primeM+1 downto 0);
           y: 		in  std_logic_vector(log2primeM+1 downto 0);
           t: 		out std_logic_vector(log2primeM+1 downto 0);
	   done:        out std_logic;
           en: 		in  std_logic;  -- Enables shifting in x register
           cmd: 	in  std_logic;  -- Enables adding and subtracting
	   sub:         in  std_logic
       ); 
end MMALU;

architecture arch_MMALU of MMALU is
   subtype counter_type is std_logic_vector(e-1 downto 0);
   
   signal cntr, cntr_next:  counter_type;

   signal xory:		   std_logic_vector(log2primeM+1 downto 0);
   signal regX: 	   std_logic_vector(log2primeM+1 downto 0);
   signal regX_ext:        std_logic_vector(log2primeM+2 downto 0);
   signal regY: 	   std_logic_vector(log2primeM+1 downto 0);
   signal regY_ext:        std_logic_vector(log2primeM+2 downto 0);
   signal regT: 	   std_logic_vector(log2primeM+1 downto 0);
   signal regT_ext:        std_logic_vector(log2primeM+2 downto 0);
   signal u:     	   std_logic;
   signal TwoComp: 	   std_logic;
   signal xY:		   std_logic_vector(log2primeM+2 downto 0);
   signal uM:   	   std_logic_vector(log2primeM+2 downto 0);
   signal Tnext: 	   std_logic_vector(log2primeM+2 downto 0);
   signal M:               std_logic_vector(log2primeM+2 downto 0);
   signal TwoM:	           std_logic_vector(log2primeM+1 downto 0);
   signal A, B, adder_out: std_logic_vector(log2primeM+2 downto 0);
   signal done_h:          std_logic;
   
   signal y_for_scaling:   std_logic_vector(log2primeM+1 downto 0);
   signal one:	           std_logic_vector(log2primeM+1 downto 0);
   signal scale:	   std_logic;

   component xor_cell
      generic(q: integer);

      port(   b:      in  std_logic_vector(q-1 downto 0);
	      a_i:    in  std_logic;
	      output: out std_logic_vector(q-1 downto 0)
	  );
   end component;

   component cell
      generic(q: integer);
      
      port(   b:      in  std_logic_vector(q-1 downto 0);
	      a_i:    in  std_logic;
              output: out std_logic_vector(q-1 downto 0)
           );
   end component;
   
   component RCadder
      generic(q: integer);
      
      port(   a:      in  std_logic_vector(q-1 downto 0);
              b:      in  std_logic_vector(q-1 downto 0);
	      c_in:   in  std_logic;
              output: out std_logic_vector(q-1 downto 0)
           );
   end component;
   
   component counter
      generic(q: integer);
      port(   input:  in  std_logic_vector(q-1 downto 0);  
	      output: out std_logic_vector(q-1 downto 0)
          );
   end component;
begin
   --Output
   t    <= regT;
   done <= done_h;

   -- Modular settings
   M  <= "000" & primeM;
   TwoM <= '0' & primeM & '0';
   
   regT_ext <= '0' & regT;
   regX_ext <= '0' & regX;
   regY_ext <= '0' & regY;

   TwoComp <= cmd and sub;
   scale   <= (not cmd) and sub;
   
   --For scaling
   one <= (0 => '1', others => '0');
   y_for_scaling: <= one when (scale = '1') else y;

   --Define registers
   reg_x: process(rst, clk)
   begin
      if clk'event and clk = '1' then
         if rst = '0' then
            regX <= (others => '0');
         elsif load = '1'then
            regX <= x;
         elsif en = '1' then
            regX <= '0' & regX(log2primeM+1 downto 1); --shifted >> 1
         else
            regX <= regX;
         end if;
      end if;
   end process;
   
   --reg_y can become 1 for scaling
   reg_y: process(rst, clk)
   begin
      if clk'event and clk = '1' then
         if rst = '0' then
            regY <= (others => '0');
         elsif load = '1' then
            regY <= xory;
         else
            regY <= regY;
         end if;
      end if;
   end process;
   
   reg_t: process(rst, clk)
   begin
      if clk'event and clk = '1' then
         if rst = '0' then
            regT <= (others => '0');
         elsif load = '1' then
            if TwoComp = '0' then
		regT <= (others => '0');
	    else
		regT <= TwoM;
	    end if;
         elsif en = '1' then
	    if cmd ='0' then
            	regT <= Tnext(log2primeM+2 downto 1); --already divided by 2
	    else
		regT <= Tnext(log2primeM+1 downto 0);
	    end if;
         else
            regT <= regT;
         end if;
      end if;
   end process;
   
   --> Algorithm voor d = 1 (per bit)
   -- u := t0 = {regT[0] + regX[0]*regY[0]} (-m0*(-1) -->1) mod 2
   -- Tnext <= {regT + --regX[0]*regY-- + --u*primeM-- } >> d
   
   u <= regT(0) xor (regX(0) and regY(0));
   
   inst_cell_2: xor_cell
      generic map(log2primeM+2)
      port map(y_for_scaling, TwoComp, xory);

   inst_cell_1: cell
      generic map(log2primeM+3)
      port map(M, u, uM);

   inst_cell_0: cell
      generic map(log2PrimeM+3)
      port map(regY_ext, regX(0), xY);
      
   RCadder_0: RCadder
      generic map(log2PrimeM+3)
      port map(regT_ext, A, '0', adder_out);

   RCadder_1: RCadder
      generic map(log2primeM+3)
      port map(adder_out, B, TwoComp, Tnext);
      
   RCadder_counter: counter
      generic map(e)
      port map(cntr, cntr_next);
      
   --For implementing add function
   -- when cmd = '1' then we use the adding function of the MALU
   -- Introduces a warning:
	
   A <= regY_ext  when (cmd = '1') else xY;   -- Or set x on 1 when cmd = 1
   B <= regX_ext  when (cmd = '1') else uM;
   
   --Timer for knowing when Montgomery ended

   --Deze blok moet nog worden nagekeken
   shift_timer: process(rst, clk)
   begin
      if clk'event and clk = '1' then
      	if rst = '0' then
	--if rst = '0' or load = '1' then
	   done_h <= '0';
      	   cntr	<= (others => '0');
	elsif load = '1' then
           done_h <= '0';
           cntr <= (others => '0');
      	elsif en = '1' then
	   if cmd = '1' then 
	      if cntr = 0 then
		done_h <= '1';
		cntr <= cntr_next;
	      else 
		done_h <= '0';
	      end if;
      	   --log2primeM moeten we wrs nog binair kunnen voorstellen?
      	   elsif cntr = log2primeM+3 then
      	   	cntr <= (others => '0');
      	   	done_h <= '1';
      	   else 
      	   	cntr 	 <= cntr_next;
      	   	done_h   <= '0';
	   end if;
        end if;
     end if;      
   end process;
   
end arch_MMALU;
