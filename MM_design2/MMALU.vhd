----------------------------------------------------------------------
-- Author: Niels Pirotte
--
-- Project Name: Masterthesis Niels Pirotte
-- Module Name: MMALU
-- Description: Modular Montgomery Multiplier using the method of Koç
-- in the paper: "A scalable Architecture for Montgomery Multiplier"
----------------------------------------------------------------------
-- General remark:
-- A bound is set to the montgomery multiplier: 16M < R.
-- This makes sure x,y < 4N results in t < 2N
-- Therefore additional modular add/sub hw is not needed
-- This means the datapath of the MMALU is 2 bits larger than the number of bits of M
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

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
   
   signal cntr_in, cntr_in_next:  counter_type;
   signal cntr_out, cntr_out_next:  counter_type;

   signal regX: 	   std_logic_vector(log2primeM+1 downto 0);
   signal regY: 	   std_logic_vector(log2primeM+3 downto 0); --moet extended worden door counter

   signal regT: 	   std_logic_vector(log2primeM+2 downto 0);
   
   signal u, t0, y0:   	   std_logic;
   signal in_0:     	   std_logic;
   signal in_1:     	   std_logic;
   signal in_2:     	   std_logic;
   signal out_0:	   std_logic;
   signal shift: 	   std_logic;
   
   signal carry:	   std_logic_vector(1 downto 0);
   signal carry_next:	   std_logic_vector(1 downto 0);
   
   signal M:               std_logic_vector(log2primeM+2 downto 0);
   signal TwoM:	           std_logic_vector(log2primeM+1 downto 0);

   signal done_h:          std_logic;

   component three_bit_adder_with_carry
   port(   in_0, in_1, in_2: in  std_logic;
   	   c_in:	     in  std_logic_vector(1 downto 0);
           s:		     out std_logic;
           c_out:	     out std_logic_vector(1 downto 0)
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
   t    <= regT(log2primeM+1 downto 0);
   done <= done_h;

   -- Modular settings
   M  <= "000" & primeM;
   TwoM <= '0' & primeM & '0';

   --Define registers
   reg_x: process(rst, clk)
   begin
      if clk'event and clk = '1' then
         if rst = '0' then
            regX <= (others => '0');
            t0 <= '0';
	    y0 <= '0';
         elsif load = '1'then
            regX <= x;
            t0 <= '0';
	    y0 <= '0';
         elsif shift = '1' and en ='1' then
            regX <= '0' & regX(log2primeM+1 downto 1); --shifted >> 1
            t0 <= regT(1);
	    y0 <= regY(1);
         else
            regX <= regX;
            t0 <= t0;
	    y0 <= y0;
         end if;
      end if;
   end process;
   
   reg_y: process(rst, clk)
   begin
      if clk'event and clk = '1' then
         if rst = '0' then
            regY <= (others => '0');
         elsif load = '1' then
            regY <= "00" & y;
         elsif en ='1' then
            regY <= regY(0) & regY(log2primeM+3 downto 1); --shifted >> 1
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
            regT <= (others => '0');
         elsif en = '1' then
            if cntr_in = 0 then
               regT <= '0' & regT(log2primeM+2 downto 1);
            elsif cntr_in = log2primeM+1 then
               regT <= carry & regT(log2primeM downto 0);
            else 
	       regT <= regT(0) & out_0 & regT(log2primeM+1 downto 1);
	    end if;
         else
            regT <= regT;
         end if;
      end if;
   end process;
   
   reg_carry: process(rst, clk)
   begin
      if clk'event and clk = '1' then
         if rst = '0' then
            carry <= "00";
         elsif load = '1' or shift ='1' then
            carry <= "00";
         elsif en = '1' then
            carry <= carry_next;
         else 
            carry <= carry;
         end if;
      end if;
   end process;
   
   -- logic
   --u <= regT(0) xor (regX(0) and regY(0));
   u <= t0 xor (regX(0) and y0);
   in_0 <= regT(0);
   in_1 <= regX(0) and regY(0);
   in_2 <= u and M(to_integer(unsigned(cntr_in)));
   
   three_bit_adder_0: three_bit_adder_with_carry
     port map(   
     	      in_0  => in_0, 
     	      in_1  => in_1, 
     	      in_2  => in_2,
   	      c_in  => carry,
              s     => out_0,
              c_out => carry_next
             );
   
   counter_outer_loop: counter
      generic map(e)
      port map(cntr_out, cntr_out_next);
      
   counter_inner_loop: counter
      generic map(e)
      port map(cntr_in, cntr_in_next);
   
   --Timer for knowing when Montgomery ended
   shift_in_outer_loop: process(rst, clk)
   begin
      if clk'event and clk = '1' then
      	if rst = '0' then
	   done_h <= '0';
      	   cntr_out <= (others => '0');
	elsif load = '1' then
           done_h <= '0';
           cntr_out <= (others => '0');
      	elsif en = '1' and shift = '1' then
      	   if cntr_out = log2primeM+3 then
      	   	cntr_out <= (others => '0');
      	   	done_h <= '1';
      	   else 
      	   	cntr_out <= cntr_out_next;
      	   	done_h   <= '0';
	   end if;
        end if;
     end if;      
   end process;
   
      --Timer for knowing when Montgomery ended
   shift_in_inner_loop: process(rst, clk)
   begin
      if clk'event and clk = '1' then
      	if rst = '0' then
	   shift <= '0';
      	   cntr_in <= (others => '0');
	elsif load = '1' then
           shift <= '0';
           cntr_in <= (others => '0');
      	elsif en = '1' then
      	   if cntr_in = log2primeM+2 then
      	   	cntr_in <= (others => '0');
      	   	shift <= '1';
      	   else 
      	   	cntr_in <= cntr_in_next;
      	   	shift   <= '0';
	   end if;
        end if;
     end if;      
   end process;
   
end arch_MMALU;
