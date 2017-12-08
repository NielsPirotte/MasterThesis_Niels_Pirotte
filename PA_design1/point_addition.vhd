--------------------------------------------------------------------------------
-- Author: Niels Pirotte
--
-- Project: Masterthesis Niels Pirotte
-- Module Name: point addition
-- Description: Defines the point addition operation
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.constants.all;

entity point_addition is
   generic(integer n := log2primeM + 2);
   port(  rst, clk:   in  std_logic;
          load:       in  std_logic;
	  X1, Y1, Z1: in  std_logic_vector(n-1 downto 0);
	  X2, Y2:     in  std_logic_vector(n-1 downto 0);
	  done:	      out std_logic;
	  X3, Y3, Z3: out std_logic_vector(n-1 downto 0)
	);
end point_addition;

architecture arch_point_addition is

begin

end arch_point_addition;
