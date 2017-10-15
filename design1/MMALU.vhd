--Implementation of a Montgommery Modular ALU (MMALU)
--cmd signal for selecting adding
--if cmd = 1 => add

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.constants.all;

entity MMALU is
   generic(q: integer := 4 -- Datapath size = bits needed to represent all numbers (max 2M)
   	  );
   port(   rst, clk: 	in  std_logic;
           load: 	in  std_logic;
           x: 		in  std_logic_vector(q downto 0);
           y: 		in  std_logic_vector(q downto 0);
           t: 		out std_logic_vector(q downto 0);
	   end_pulse:   out std_logic;
           en: 		in  std_logic; -- Enables shifting in x register
           cmd: 	in std_logic   -- Enables adding
       ); 
end MMALU;

architecture arch_MMALU of MMALU is
   subtype timer        std_logic_vector(e-1 downto 0);
   
   signal t, t_next:	timer;

   signal regX: 	std_logic_vector(q downto 0);
   signal regY: 	std_logic_vector(q downto 0);
   signal regT: 	std_logic_vector(q downto 0);
   signal u: 		std_logic;
   signal xY:		std_logic_vector(q downto 0);
   signal uM:   	std_logic_vector(q downto 0);
   signal Tnext: 	std_logic_vector(q downto 0);
   signal M: 		std_logic_vector(q downto 0);
   signal A, B, adder_output_0: std_logic_vector(q downto 0);

   component cell
      generic(d: integer);
      
      port(   b:      in  std_logic_vector(q downto 0);
	      a_i:    in  std_logic;
              output: out std_logic_vector(q downto 0)
           );
   end component;
   
   component RCadder
      generic(q: integer);
      
      port(   a:      in  std_logic_vector(q downto 0);
              b:      in  std_logic_vector(q downto 0);
              output: out std_logic_vector(q downto 0)
           );
   end component;
begin
   --Output
   t<=regT;
   --M
   M <= '0' & primeM;
   
   --Define registers
   reg_x: process(rst, clk)
   begin
      if clk'event and clk = '1' then
         if rst = '0' then
            regX <= (others => '0');
         elsif load = '1'then
            regX <= x;
         elsif en = '1' then
            regX <= '0' & regX(q downto 1); --shift with wordsize to left [<< d]
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
            regT <= '0' & Tnext(q downto 1); -- with div d
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
      generic map(q)
      port map(M, u, uM);

   inst_cell_0: cell
      generic map(q)
      port map(regY, regX(0), xY);
      
   RCadder_0: RCadder
      generic map(q)
      port map(regT, A, adder_output_0);

   RCadder_1: RCadder
      generic map(q)
      port map(adder_output_0, B, Tnext);
      
   RCadder_timer: RCadder
      generic map(e)
      port map(t, '1', '0', open, t_next);  
      
   --For implementing add function
   -- when cmd = '1' then we use the adding function of the MALU
   A <= regY when (cmd = '1') else xY;
   B <= (others => '0') when (cmd = '1') else uM;
   
   --Timer for knowing when Montgomery ended
      --Define registers
   shift_timer: process(rst, clk)
   begin
      if clk'event and clk = '1' then
      	if rst = '0' then
      	   end_pulse 	<= '0';
      	   t 		<= (others => '0');
      	elsif en = '1' then
      	   if(t = q  then --q moeten we wrs nog binair kunnen voorstellen
      	   	t 	  <= (others => '0');
      	   	end_pulse <= '1';
      	   else 
      	   --Deze adder gaat plaats in beslag nemen op een ASIC
      	   -- => overhead met vorige design
      	   	t 	 <= t_next;
      	   	shift_en <= '0';
      	else 
      	   t 		<= t;
      	   end_pulse    <= end_pulse;
        end if;
     end if;      
   end
   
end arch_MMALU;
