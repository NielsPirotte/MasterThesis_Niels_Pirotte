----------------------------------------------------------------------------------
-- 
-- Authors: Nele Mentens and Tim Güneysu
--  
-- Modified by: Niels Pirotte
-- Project Name: Masterthesis Niels Pirotte
-- Module Name: tb_pointmult 
-- Description: testbench for the pointmult module
----------------------------------------------------------------------------------

-- include the IEEE library and the STD_LOGIC_1164 package for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- include the library constants
use work.constants.all;

-- describe the interface of the module: a testbench does not have any inputs or outputs
entity tb_pointmult is
	generic(
		 n: integer := log2primeM + 2;
    	         --key parameters yet to be added 
	    	 s: integer := 4;
		 log2s:integer := 2		
	      );
end tb_pointmult;

architecture behavioral of tb_pointmult is

    signal X, Y, Z: 		  std_logic_vector(n-1 downto 0);
    signal m: 	 		  std_logic_vector(s-1 downto 0);
    signal en, load:	 	  std_logic := '0';
    --signal r:				std_logic; -- random bit for random order excecution
    signal rst, clk_i:	 	  std_logic := '0';
    
    -- declare internal signals to read out the outputs of pointmult
    signal done: 		  std_logic;
    signal resX, resY, resZ:	  std_logic_vector(n-1 downto 0);

    -- define the clock period
    constant clk_period: time := 1000 us;

    -- declare the modaddn_mult5 component
    component pointmult
        generic(
            n: integer;
    	    --key parameters yet to be added 
	    s: integer;
            log2s: integer);
    	port(   
    	    X, Y, Z: 		in  std_logic_vector(n-1 downto 0);
	    m: 			in  std_logic_vector(s-1 downto 0);
            rst, clk:	 	in  std_logic;
            ce:			in  std_logic;
            load:		in  std_logic;
            r:			in  std_logic; --random bit for random order excecution
            resX, resY, resZ:	out std_logic_vector(n-1 downto 0);
            done: 		out std_logic);
    end component;

begin

    -- instantiate the modaddn_mult5 component
    -- map the generic parameter in the testbench to the generic parameter in the component  
    -- map the signals in the testbench to the ports of the component
    inst_pointmult: pointmult
        generic map(n => n,
		    s => s,
		    log2s => log2s
		    )
        port map(   
        	  X    => X,
        	  Y    => Y,
        	  Z    => Z,
	    	  m    => m,
            	  rst  => rst,
            	  clk  => clk_i,
            	  ce   => en,
            	  load => load,
            	  r    => '1',
            	  resX => resX,
            	  resY => resY,
            	  resZ => resZ,
            	  done => done
                );
    
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
        wait for 10*clk_period;
    
        rst <= '0';
    
        wait for clk_period;
    
        rst <= '1';
    
        wait for clk_period;
    
        X <= "00000";
        Y <= "00100";
        Z <= "00001";
        -- m consists of 4 bits --> first bit always must be 1
        m <= "1101"; -- m = 13
        load <= '1';
    
        wait for clk_period;
    
        load <= '0';
        en <= '1';
    
        wait on done;
        wait for 2*clk_period;
            
        en <= '0';

        wait;
    end process;
                
end behavioral;
