----------------------------------------------------------------------------------
-- 
-- Authors: Nele Mentens and Tim Güneysu
--  
-- Project Name: Masterthesis Niels Pirotte
-- Module Name: tb_pointmult 
-- Description: testbench for the pointmult module
----------------------------------------------------------------------------------

-- include the IEEE library and the STD_LOGIC_1164 package for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- describe the interface of the module: a testbench does not have any inputs or outputs
entity tb_pointmult is
    generic(width: integer := 8;
            log2width: integer := 3);
end tb_pointmult;

architecture behavioral of tb_pointmult is

    -- declare and initialize internal signals to drive the inputs of modaddn_mult5
    signal a_i, b_i, p_i: std_logic_vector(width-1 downto 0) := (others => '0');
    signal rst_i, clk_i, start_i: std_logic := '0';
    
    -- declare internal signals to read out the outputs of modaddn_mult5
    signal product_i: std_logic_vector(width-1 downto 0);
    signal done_i: std_logic;

    -- define the clock period
    constant clk_period: time := 10 ns;

    -- declare the modaddn_mult5 component
    component pointmult
        generic(n: integer := 8;
		s: integer := 8;
                log2s: integer := 3);
        port(   Q, p: in std_logic_vector(n-1 downto 0);
		m: in std_logic_vector(s-1 downto 0);
                rst, clk, start: in std_logic;
                product: out std_logic_vector(n-1 downto 0);
                done: out std_logic);
    end component;

begin

    -- instantiate the modaddn_mult5 component
    -- map the generic parameter in the testbench to the generic parameter in the component  
    -- map the signals in the testbench to the ports of the component
    inst_pointmult: pointmult
        generic map(n => width,
		    s => width,
                    log2s => log2width)
        port map(   Q => a_i,
                    m => b_i,
                    p => p_i,
                    rst => rst_i,
                    clk => clk_i,
                    start => start_i,
                    product => product_i,
                    done => done_i);
    
    -- generate the clock with a duty cycle of 50%
    gen_clk: process
    begin
         clk_i <= '0';
         wait for clk_period/2;
         clk_i <= '1';
         wait for clk_period/2;
    end process;

    -- stimulus process (without sensitivity list, but with wait statements)
    stim: process
    begin
        wait for 100 ns;
    
        rst_i <= '1';
    
        wait for 10 ns;
    
        rst_i <= '0';
    
        wait for 10 ns;
    
        a_i <= "10101101";
        b_i <= "10011001";
        p_i <= "11111101";
        start_i <= '1';
    
        wait for 10 ns;
    
        start_i <= '0';
    
        wait until done_i = '1';
        wait for 15 ns;
    
        a_i <= "01111011";
        b_i <= "00101000";
        p_i <= "11111101";
        start_i <= '1';
            
        wait for 10 ns;
            
        start_i <= '0';

        wait;
    end process;
                
end behavioral;
