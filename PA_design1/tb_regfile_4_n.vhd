----------------------------------------------------------------------------------
-- ECC School - Hardware Tutorial 
-- Nijmegen, November 9-11, 2017 
-- 
-- Authors: Nele Mentens and Tim Güneysu
--  
-- Project Name: ECCcore
-- Module Name: tb_regfile_4_n 
-- Description: testbench for the regfile_4_n module
----------------------------------------------------------------------------------

-- include the IEEE library and the STD_LOGIC_1164 package for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- describe the interface of the module: a testbench does not have any inputs or outputs
entity tb_regfile_4_n is
    generic(width: integer := 8);
end tb_regfile_4_n;

architecture behavioral of tb_regfile_4_n is

    -- declare and initialize internal signals to drive the inputs of regfile_4_n
    signal din_i: std_logic_vector(width-1 downto 0) := (others => '0');
    signal waddr_i, raddr0_i, raddr1_i: std_logic_vector(1 downto 0) := (others => '0');
    signal rst_i, clk_i, we_i: std_logic := '0';
    
    -- declare internal signals to read out the outputs of regfile_4_n
    signal dout0_i, dout1_i: std_logic_vector(width-1 downto 0);

    -- define the clock period
    constant clk_period: time := 10 ns;

    -- declare the regfile_4_n component
    component regfile_4_n is
        generic(n: integer := 8);
        port(   din: in std_logic_vector(n-1 downto 0);
                waddr, raddr0, raddr1: in std_logic_vector(1 downto 0);
                rst, clk, we: in std_logic;
                dout0, dout1: out std_logic_vector(n-1 downto 0));
    end component;

begin

    -- instantiate the regfile_4_n component
    -- map the generic parameter in the testbench to the generic parameter in the component  
    -- map the signals in the testbench to the ports of the component
    inst_regfile_4_n: regfile_4_n
        generic map(n => width)
        port map(   din => din_i,
                    waddr => waddr_i,
                    raddr0 => raddr0_i,
                    raddr1 => raddr1_i,
                    rst => rst_i,
                    clk => clk_i,
                    we => we_i,
                    dout0 => dout0_i,
                    dout1 => dout1_i);

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
        din_i <= "10110110";
        we_i <= '1';
        waddr_i <= "01";
        raddr0_i <= "01";
        raddr1_i <= "11";
        
        wait for 10 ns;
        
        din_i <= "01011100";
        waddr_i <= "11";
        
        wait;
    end process;
                
end behavioral;