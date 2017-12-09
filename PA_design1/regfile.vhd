---------------------------------------------------------------------------------
-- Author: Niels Pirotte
--  
-- Project Name: Masterthesis Niels Pirotte
-- Module Name: regfile
-- Description: register file with depth  and width log2primeM + 2 (size inputs 
--		MMALU) 
---------------------------------------------------------------------------------

-- include the STD_LOGIC_1164 package in the IEEE library for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- include the STD_LOGIC_UNSIGNED package for arithmetic operations
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- describe the interface of the module
entity regfile is
    generic(n: integer := log2primeM + 2);
    port(   din:                   in  std_logic_vector(n-1 downto 0);
	    --Onderstaande moet nog worden geoptimaliseerd
            waddr, raddr0, raddr1: in  std_logic_vector(2 downto 0); 
            rst, clk, we:          in  std_logic;
	    load_op1, load_op2:    in  std_logic;
	    X1, Y1, Z1:            in  std_logic_vector(n-1 downto 0);
	    X2, Y2:                in  std_logic_vector(n-1 downto 0);
            dout0, dout1:          out std_logic_vector(n-1 downto 0);
	    X3, Y3, Z3:            out std_logic_vector(n-1 downto 0));
end regfile;

-- describe the behavior of the module in the architecture
architecture arch_regfile of regfile is

    -- declare internal signals
	signal regX1, regY1, regZ1, regX2: std_logic_vector(n-1 downto 0);
	signal regY2, regt0, regt1, regt2: std_logic_vector(n-1 downto 0);
	signal regt3:			   std_logic_vector(n-1 downto 0);
	signal enX1, enY1, enZ1, enX2, enY2: std_logic;
	signal ent0, ent1, ent2, ent3:	     std_logic;
	
begin
    -- for testing purposes
    X3 <= regX1;
    Y3 <= regY1;
    Z3 <= regZ1;    

    -- decode the write address ('waddr') when the write enable ('we') is '1'
    decode: process(we, waddr)
    begin
        if we = '0' then
            enX1 <= '0';
            enY1 <= '0';
            enZ1 <= '0';
            enX2 <= '0';
            enY2 <= '0';
            ent0 <= '0';
            ent1 <= '0';
            ent2 <= '0';
            ent3 <= '0';
        else                                    
            case waddr is
                when "000" =>
                    enX1 <= '1';
		    enY1 <= '0';
		    enZ1 <= '0';
		    enX2 <= '0';
		    enY2 <= '0';
		    ent0 <= '0';
		    ent1 <= '0';
		    ent2 <= '0';
		    ent3 <= '0';
                when "001" =>
		    enX1 <= '0';
		    enY1 <= '1';
		    enZ1 <= '0';
		    enX2 <= '0';
		    enY2 <= '0';
		    ent0 <= '0';
		    ent1 <= '0';
		    ent2 <= '0';
		    ent3 <= '0';
                when "010" =>
                    enX1 <= '0';
		    enY1 <= '0';
		    enZ1 <= '1';
		    enX2 <= '0';
		    enY2 <= '0';
		    ent0 <= '0';
		    ent1 <= '0';
		    ent2 <= '0';
		    ent3 <= '0';
                when "011" =>
                    enX1 <= '0';
		    enY1 <= '0';
		    enZ1 <= '0';
		    enX2 <= '1';
		    enY2 <= '0';
		    ent0 <= '0';
		    ent1 <= '0';
		    ent2 <= '0';
		    ent3 <= '0';
                when "100" =>
                    enX1 <= '0';
		    enY1 <= '0';
		    enZ1 <= '0';
		    enX2 <= '0';
		    enY2 <= '0';
		    ent0 <= '1';
		    ent1 <= '0';
		    ent2 <= '0';
		    ent3 <= '0';
                when "101" =>
                    enX1 <= '0';
		    enY1 <= '0';
		    enZ1 <= '0';
		    enX2 <= '0';
		    enY2 <= '0';
		    ent0 <= '0';
		    ent1 <= '1';
		    ent2 <= '0';
		    ent3 <= '0';
                when "110"=>
                    enX1 <= '0';
		    enY1 <= '0';
		    enZ1 <= '0';
		    enX2 <= '0';
		    enY2 <= '0';
		    ent0 <= '0';
		    ent1 <= '0';
		    ent2 <= '1';
		    ent3 <= '0';
                when others =>
                    enX1 <= '0';
		    enY1 <= '0';
		    enZ1 <= '0';
		    enX2 <= '0';
		    enY2 <= '0';
		    ent0 <= '0';
		    ent1 <= '0';
		    ent2 <= '0';
		    ent3 <= '1';
            end case;
        end if;
    end process;

    -- store 'din' in the register with an active enable
    registers: process(rst, clk)
    begin
        if rst = '0' then
            regX1 <= (others => '0');
            regY1 <= (others => '0');
            regZ1 <= (others => '0');
            regX2 <= (others => '0');
            regY2 <= (others => '0');
            regt0 <= (others => '0');
            regt1 <= (others => '0');
            regt2 <= (others => '0');
            regt3 <= (others => '0');
        elsif clk'event and clk = '1' then
	    if load_op2 = '1' then
		if load_op1 = '1' then
		   regX1 <= X1;
		   regY1 <= Y1;
		   regZ1 <= Z1;
		end if;
		regX2 <= X2;
		regY2 <= Y2;
            elsif enX1 = '1' then
                regX1 <= din;
            elsif enY1 = '1' then
                regY1 <= din;
            elsif enZ1 = '1' then
                regZ1 <= din;
            elsif enX2 = '1' then
                regX2 <= din;
            elsif ent0 = '1' then
            	regt0 <= din;
            elsif ent1 = '1' then
            	regt1 <= din;
            elsif ent2 = '1' then
            	regt2 <= din;
            elsif ent3 = '1' then
            	regt3 <= din;
            end if;
        end if;
    end process;
    
    -- assign 'dout0' based on 'raddr0'
    -- Right Operand
    mux0: process(raddr0, regX1, regY1, regZ1, regX2, regt0, regt2)
    begin
        case raddr0 is
            when "000" =>
                dout0 <= regX1;
            when "001" =>
                dout0 <= regY1;
            when "010" =>
                dout0 <= regZ1;
            when "011" =>
            	dout0 <= regX2;
            when "100" =>
            	dout0 <= regt0;
            when "101" =>
            	dout0 <= regt2;
            when others =>
                dout0 <= regX1;
        end case;
    end process;

    -- assign 'dout0' based on 'raddr0'
    -- Left Operand
    mux1: process(raddr1, regX2, regY1, regY2, regt0, regt1, regt3)
    begin
        case raddr1 is
            when "000" =>
                dout1 <= regX2;
            when "001" =>
                dout1 <= regY1;
            when "010" =>
                dout1 <= regY2;
            when "011" =>
            	dout1 <= regt0;
            when "100" =>
            	dout1 => regt1;
            when "101" =>
            	dout1 => regt3;
            when "110" =>
            	dout1 => "00" & B3;
            when others =>
                dout1 <= "00" & R1;
        end case;
    end process;
    
end arch_regfile;
