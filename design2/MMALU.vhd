--Implementation of a Montgommery Modular ALU (MMALU)
--cmd signal for selecting adding
--if cmd = 1 => add

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.constants.all;

entity MMALU is
   generic(d: integer := d; -- Word size
           q: integer := w -- Datapath size
   );
   port(   rst, clk: in  std_logic;
           load:     in  std_logic;
           x:        in  std_logic_vector((q*d)-1 downto 0);
           y:        in  std_logic_vector((q*d)-1 downto 0);
           t:        out std_logic_vector((q*d)-1 downto 0);
           en:       in  std_logic; 				-- Enables shifting in x register
           cmd:      in std_logic); 				-- Enables adding 
end MMALU;

architecture arch_MMALU of MMALU is
   signal regX: 	std_logic_vector((q*d)-1 downto 0);
   signal regY: 	std_logic_vector((q*d)-1 downto 0);
   signal regT: 	std_logic_vector((q*d)-1 downto 0);
   --signal zero_d: 	std_logic_vector(d-1 downto 0);
   signal u: 		std_logic;
   signal xY:	        std_logic_vector(d-1 downto 0);
   signal uM:   	std_logic_vector(d-1 downto 0);
   
   signal adder_1_out   std_logic_vector(d-1 downto 0);
   signal adder_1_C     std_logic;
   signal adder_2_C     std_logic; 
   
   signal Cin1          std_logic;
   signal Cin2          std_logic;
   --not yet sure
   signal Tnext: std_logic_vector(q-1+d downto 0);
   signal M: 	std_logic_vector(q-1+d downto 0);

   component cell
      generic(d: integer);
      
      port(   b:      in  std_logic_vector(d-1 downto 0);
	      a_i:    in  std_logic;
              output: out std_logic_vector(d-1 downto 0)
      );
   end component;
   
   component RCadder
      generic(d: integer);
      
      port(   a:      in  std_logic_vector(d-1 downto 0);
              b:      in  std_logic_vector(d-1 downto 0);
              c_in:   in  std_logic;
              c_out   out std_logic;
              output: out std_logic_vector(d-1 downto 0)
      );
    end component;
    
begin
   --Output
	t<=regT;

   --Zero word --> necessary?
   --zero_d <= (others => '0');
   
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
            regX <= '0' & regX((q*d)-1 downto 1); --shift with 1 bit to left [<< 1]
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
            regY <= regY(d-1 downto 0) & regY((q*d)-1 downto d);
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
            regT <= '0' & Tnext(qed downto d); -- with div d 
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
      generic map(d)
      port map(M(d-1 downto 0), u, uM);

   inst_cell_0: cell
      generic map(d)
      port map(regY(d-1 downto 0), regX(0), xY);
   
   Cin1 <= adder_1_C and adder_2_C;
   Cin2 <= adder_2_C;
      
   RCadder_0: RCadder
      generic map(d)
      port map(regT(), xY, Cin1, adder_1_C, adder_1_out);

   RCadder_1: RCadder
      generic map(d)
      port map(adder_1_out, B, Cin2, adder_2_C, Tnext);   
      
   --Nog na te kijken   
      
   --For implementing add function
   -- when cmd = '1' then we use the adding function of the MALU
   --A <= regY when (cmd = '1') else xY;
   --B <= (others => '0') when (cmd = '1') else uM;
   
end arch_MMALU;
