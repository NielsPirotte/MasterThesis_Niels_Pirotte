----------------------------------------------------------------------------------
-- ECC School - Hardware Tutorial 
-- Nijmegen, November 9-11, 2017 
-- 
-- Authors: Nele Mentens and Tim Güneysu
--  
-- Project Name: ECCcore
-- Module Name: modaddsubn
-- Description: n-bit modular adder/subtracter
----------------------------------------------------------------------------------

-- include the STD_LOGIC_1164 package in the IEEE library for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- include the STD_LOGIC_UNSIGNED package for arithmetic operations
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- describe the interface of the module
-- if as = '0': sum = (a + b) mod p
-- if as = '1': sum = (a - b) mod p 
entity modaddsubn is
    generic(n: integer := 8);
    port(   a, b, p: in std_logic_vector(n-1 downto 0);
            as: in std_logic;
            sum: out std_logic_vector(n-1 downto 0));
end modaddsubn;

-- describe the behavior of the module in the architecture
architecture behavioral of modaddsubn is

    -- declare internal signals
	signal a_long, b_long, p_long, c, d: std_logic_vector(n downto 0);
	signal as_not: std_logic;
	
	-- declare the addsubn component
    component addsubn
        generic(n: integer := 8);
        port(   a, b: in std_logic_vector(n-1 downto 0);
                as: in std_logic;
                sum: out std_logic_vector(n-1 downto 0));
    end component;

begin

    -- extend a and b with one bit because the "+" and "-" operators expect the inputs and output to be of equal length 
    a_long <= '0' & a;
    b_long <= '0' & b;
    p_long <= '0' & p;

    -- invert as
    as_not <= not as;
    
    -- instantiate the first addsubn component
    -- map the generic parameter in the top design to the generic parameter in the component  
    -- map the signals in the top design to the ports of the component
    inst_addsubn_1: addsubn
        generic map(n => n+1)
        port map(   a => a_long,
                    b => b_long,
                    as => as,
                    sum => c);

    -- instantiate the second addsubn component
    -- map the generic parameter in the top design to the generic parameter in the component  
    -- map the signals in the top design to the ports of the component
    inst_addsubn_2: addsubn
        generic map(n => n+1)
        port map(   a => c,
                    b => p_long,
                    as => as_not,
                    sum => d);

	-- in the case of a modular addition, assign d to the sum output if d is a positive number
	-- in the case of a modular addition, assign c to the sum output if d is a negative number
	-- in the case of a modular subtraction, assign c to the sum output if c is a positive number
	-- in the case of a modular subtraction, assign d to the sum output if c is a negative number
	-- leave the MSB out of the assignment because it is always '0'
	mux: process(as, c, d)
	begin
        if as = '0' then
            if d(n) = '0' then
                sum <= d(n-1 downto 0);
            else
                sum <= c(n-1 downto 0);
            end if;
        else
            if c(n) = '0' then
                sum <= c(n-1 downto 0);
            else
                sum <= d(n-1 downto 0);
            end if;
        end if;
	end process;

end behavioral;