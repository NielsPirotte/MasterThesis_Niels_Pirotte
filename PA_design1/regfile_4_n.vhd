----------------------------------------------------------------------------------
-- ECC School - Hardware Tutorial 
-- Nijmegen, November 9-11, 2017 
-- 
-- Authors: Nele Mentens and Tim Güneysu
--  
-- Project Name: ECCcore
-- Module Name: regfile_4_n
-- Description: register file with depth 4 and width n
----------------------------------------------------------------------------------

-- include the STD_LOGIC_1164 package in the IEEE library for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- include the STD_LOGIC_UNSIGNED package for arithmetic operations
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- describe the interface of the module
entity regfile_4_n is
    generic(n: integer := 8);
    port(   din: in std_logic_vector(n-1 downto 0);
            waddr, raddr0, raddr1: in std_logic_vector(1 downto 0);
            rst, clk, we: in std_logic;
            dout0, dout1: out std_logic_vector(n-1 downto 0));
end regfile_4_n;

-- describe the behavior of the module in the architecture
architecture behavioral of regfile_4_n is

    -- declare internal signals
	signal reg0, reg1, reg2, reg3: std_logic_vector(n-1 downto 0);
	signal en0, en1, en2, en3: std_logic;
	
begin

    -- decode the write address ('waddr') when the write enable ('we') is '1'
    decode: process(we, waddr)
    begin
        if we = '0' then
            en0 <= '0';
            en1 <= '0';
            en2 <= '0';
            en3 <= '0';
        else                                    
            case waddr is
                when "00" =>
                    en0 <= '1';
                    en1 <= '0';
                    en2 <= '0';
                    en3 <= '0';
                when "01" =>
                    en0 <= '0';
                    en1 <= '1';
                    en2 <= '0';
                    en3 <= '0';
                when "10" =>
                    en0 <= '0';
                    en1 <= '0';
                    en2 <= '1';
                    en3 <= '0';
                when others =>
                    en0 <= '0';
                    en1 <= '0';
                    en2 <= '0';
                    en3 <= '1';
            end case;
        end if;
    end process;

    -- store 'din' in the register with an active enable
    registers: process(rst, clk)
    begin
        if rst = '1' then
            reg0 <= (others => '0');
            reg1 <= (others => '0');
            reg2 <= (others => '0');
            reg3 <= (others => '0');
        elsif clk'event and clk = '1' then
            if en0 = '1' then
                reg0 <= din;
            elsif en1 = '1' then
                reg1 <= din;
            elsif en2 = '1' then
                reg2 <= din;
            elsif en3 = '1' then
                reg3 <= din;
            end if;
        end if;
    end process;
    
    -- assign 'dout0' based on 'raddr0'
    mux0: process(raddr0, reg0, reg1, reg2, reg3)
    begin
        case raddr0 is
            when "00" =>
                dout0 <= reg0;
            when "01" =>
                dout0 <= reg1;
            when "10" =>
                dout0 <= reg2;
            when others =>
                dout0 <= reg3;
        end case;
    end process;

    -- assign 'dout0' based on 'raddr0'
    mux1: process(raddr1, reg0, reg1, reg2, reg3)
    begin
        case raddr1 is
            when "00" =>
                dout1 <= reg0;
            when "01" =>
                dout1 <= reg1;
            when "10" =>
                dout1 <= reg2;
            when others =>
                dout1 <= reg3;
        end case;
    end process;
    
end behavioral;