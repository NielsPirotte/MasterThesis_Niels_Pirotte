----------------------------------------------------------------------------------
-- 
-- Authors: Niels Pirotte
--  
-- Project Name: ECCcore
-- Module Name: tb_regfile
-- Description: testbench for the regfile module
----------------------------------------------------------------------------------

-- include the IEEE library and the STD_LOGIC_1164 package for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- describe the interface of the module: a testbench does not have any inputs or outputs
entity tb_regfile is
   generic(n: integer := log2primeM + 2);
end tb_regfile;

architecture behavioral of tb_regfile is

    -- declare and initialize internal signals to drive the inputs of regfile_4_n
    signal din: std_logic_vector(width-1 downto 0) := (others => '0');
    signal waddr, raddr0, raddr1: std_logic_vector(1 downto 0) := (others => '0');
    signal rst, clk, we: std_logic := '0';
    signal load: std_logic;
    signal X1, Y1, Z1, X2, Y2, X3, Y3, Z3: std_logic_vector(n-1 downto 0);
    
    -- declare internal signals to read out the outputs of regfile_4_n
    signal dout0, dout1: std_logic_vector(n-1 downto 0);

    -- define the clock period
    constant clk_period: time := 10 ns;

    -- declare the regfile_4_n component
    component regfile
   	generic(n: integer := log2primeM + 2);
    	port(   din:                   in  std_logic_vector(n-1 downto 0);
            	waddr, raddr0, raddr1: in  std_logic_vector(2 downto 0);
            	rst, clk, we:          in  std_logic;
		load_op1, load_op2:    in  std_logic;
		X1, Y1, Z1:            in  std_logic_vector(n-1 downto 0);
		X2, Y2:		       in  std_logic_vector(n-1 downto 0);
            	dout0, dout1:          out std_logic_vector(n-1 downto 0);
            	X3, Y3, Z3:            out std_logic_vector(n-1 downto 0)
            );
   end component;

begin

    -- instantiate the regfile_4_n component
    -- map the generic parameter in the testbench to the generic parameter in the component  
    -- map the signals in the testbench to the ports of the component
    inst_regfile: regfile
        port map(din      => din,
      	       waddr      => waddr, 
      	       raddr0     => raddr0, 
      	       raddr1     => raddr1, 
      	       rst        => rst,
      	       clk        => clk, 
      	       we         => we,
      	       load_op1   => load,
      	       load_op2   => load,
      	       X1         => X1,
      	       Y1	  => Y1,
      	       Z1	  => Z1,
      	       X2 	  => X2,
      	       Y2	  => Y2,
      	       dout0      => dout0, 
      	       dout1      => dout1, 
      	       X3         => X3,
      	       Y3         => Y3,
      	       Z3         => Z3);


    -- generate the clock with a duty cycle of 50%
    gen_clk: process
    begin
         clk_i <= '0';
         wait for clk_period/2;
         clk_i <= '1';
         wait for clk_period/2;
    end process;

    -- Not yet implemented
    
    -- stimulus process (without sensitivity list, but with wait statements)
    stim: process
    begin
        wait for 100 ns;
        
        rst <= '0';
        
        wait for 10 ns;
        
        rst_i <= '1';        
        din <= "10110110";
        we <= '1';
        waddr <= "01";
        raddr0 <= "01";
        raddr1 <= "11";
        
        wait for 10 ns;
        
        din <= "01011100";
        waddr <= "11";
        
        wait;
    end process;
                
end behavioral;