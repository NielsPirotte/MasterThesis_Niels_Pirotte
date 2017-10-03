--Implementation of a Montgommery Modular ALU (MMALU)
--cmd signal for selecting adding
--if cmd = 1 => add

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.constants.all;

entity MMALU is
   generic(d: integer := 1; -- Word size
           q: integer := 4 -- Datapath size
		   );
   port(   rst, clk: in std_logic;
           load: in std_logic;
           x: in std_logic_vector(q-1+d downto 0);
           y: in std_logic_vector(q-1+d downto 0);
           t: out std_logic_vector(q-1+d downto 0);
	debugx: out std_logic_vector(q-1+d downto 0);
	debugy: out std_logic_vector(q-1+d downto 0);
           en: in std_logic; -- Enables shifting in x register
           cmd: in std_logic); -- Enables adding 
end MMALU;

architecture arch_MMALU of MMALU is
   signal regX: std_logic_vector(q-1+d downto 0);
   signal regY: std_logic_vector(q-1+d downto 0);
   signal regT: std_logic_vector(q-1+d downto 0);
   signal zero_d: std_logic_vector(d-1 downto 0);
   signal u: 	std_logic;
   signal xY:	std_logic_vector(q-1+d downto 0);
   signal uM:   std_logic_vector(q-1+d downto 0);
   signal Tnext: std_logic_vector(q-1+d downto 0);
   signal M: 	std_logic_vector(q-1+d downto 0);
   signal A, B, adder_output_0: std_logic_vector(q-1+d downto 0);

   component cell
      generic(d: integer;
              q: integer);
      port(   b: in std_logic_vector(q-1+d downto 0);
			  a_i: in std_logic;
              output: out std_logic_vector(q-1+d downto 0)
           );
   end component;
   
   component RCadder
      generic(d: integer;
              q: integer);
	  port(   a: in std_logic_vector(q-1+d downto 0);
              b: in std_logic_vector(q-1+d downto 0);
              output: out std_logic_vector(q-1+d downto 0)
           );
   end component;
begin
   --Output
	t<=regT;
	debugx<=regX;
	debugy<=regY;
   --Zero word
   zero_d <= (others => '0');
   --M
   M <= zero_d & primeM;
   
   --Define registers
   reg_x: process(rst, clk)
   begin
      if clk'event and clk = '1' then
         if rst = '0' then
            regX <= (others => '0');
         elsif load = '1'then
            regX <= x;
         elsif en = '1' then
            regX <= zero_d & regX(q-1+d downto d); --shift with wordsize to left [<< d]
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
            regT <= zero_d & Tnext(q-1+d downto d); -- with div d
         else
            regT <= regT;
         end if;
      end if;
   end process;
   
   --> Algorithm voor d = 1 (per bit)
   -- u := t0 = {regT[0] + regX[0]*regY[0]} (-m0^(-1) -->1) mod 2
   -- Tnext <= {regT + --regX[0]*regY-- + --u*primeM-- } >> d
   
   u <= regT(0) xor (regX(0) and regY(0));
   
   inst_cell_1: cell
      generic map(d, q)
      port map(M, u, uM);

   inst_cell_0: cell
      generic map(d, q)
      port map(regY, regX(0), xY);
      
   RCadder_0: RCadder
	  generic map(d, q)
      port map(regT, A, adder_output_0);

   RCadder_1: RCadder
	  generic map(d, q)
      port map(adder_output_0, B, Tnext);   
      
   --For implementing add function
   -- when cmd = '1' then we use the adding function of the MALU
   A <= regY when (cmd = '1') else xY;
   B <= (others => '0') when (cmd = '1') else uM;
   
end arch_MMALU;