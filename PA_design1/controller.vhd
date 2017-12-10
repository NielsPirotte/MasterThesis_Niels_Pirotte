--------------------------------------------------------------------------------
-- Author: Niels Pirotte
--
-- Project: Masterthesis Niels Pirotte
-- Module Name: controller
-- Description: Transferring opcode FSM to control signals for the MMALU and 
--		Register file.
-- load = set on high to to load the inputs provided by LO- and RO-address in the
--	  MMALU
-- cmd  = set on high to use add/subtract function on MMALU
-- sub  = set on high to subtract
-- wen  = set on high to write back to the register file 
--------------------------------------------------------------------------------

-- Load signaal moet nog worden weggelaten

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.constants.all;

entity controller is

   port(opcode: in  std_logic_vector(2 downto 0);
        load:     out std_logic;
        cmd:    out std_logic;
        sub:    out std_logic;
        wen:    out std_logic
        );
end controller;

architecture arch_controller of controller is
   begin
   process (opcode)
      begin
      load <= '0'; cmd <= '0'; sub <= '0'; wen <= '0';
         case opcode is
	    when "000" => 
		load <= '1';
		wen <= '1';
 	    when "001" =>
		load <= '1';
		wen <= '1';
		cmd <= '1';
	    when "010" =>
		load <= '1';
		wen <= '1';
		cmd <= '1';
		sub <= '1';
	   when others =>
	   end case;
      end process;
end arch_controller;
