--------------------------------------------------------------------------------
-- Author: Niels Pirotte
--
-- Project: Masterthesis Niels Pirotte
-- Module Name: point addition
-- Description: Defines the point addition operation

-- Remark: For point addition to work properly, only x2 and y2 need to be 
--         transformed to the Montgomery domain. 
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.constants.all;

entity point_addition is
   generic(n: integer := log2primeM + 2);
   port(  rst, clk:   in  std_logic;
          load_op1:   in  std_logic;
          load_op2:   in  std_logic;
          en:	      in  std_logic;
	  X1, Y1, Z1: in  std_logic_vector(n-1 downto 0);
	  X2, Y2, Z2: in  std_logic_vector(n-1 downto 0);
	  done:	      out std_logic;
	  X3, Y3, Z3: out std_logic_vector(n-1 downto 0)
	);
end point_addition;

architecture arch_point_addition of point_addition is
   component FSM
   	 port (
	    reset : in STD_LOGIC;
	    clock : in STD_LOGIC;

	    -- INPUT
	    ce :   	 in STD_LOGIC;
	    MMALU_done : in STD_LOGIC;

	   -- OUTPUT
	    opcode :     out STD_LOGIC_VECTOR(1 downto 0);
	    Asel :       out STD_LOGIC_VECTOR(2 downto 0);
	    Bsel :       out STD_LOGIC_VECTOR(2 downto 0);
	    Csel :       out STD_LOGIC_VECTOR(2 downto 0);
            load_MMALU:  out STD_LOGIC;
	    done:        out STD_LOGIC
	  );
   end component;
   
   component controller
   	port(
   	   opcode: in  std_logic_vector(1 downto 0);
           cmd:    out std_logic;
           sub:    out std_logic
        );
   end component;
   
   component regfile
   	generic(n: integer := log2primeM + 2);
    	port(   din:                   in  std_logic_vector(n-1 downto 0);
            	waddr, raddr0, raddr1: in  std_logic_vector(2 downto 0);
            	rst, clk, we:          in  std_logic;
		load_op1, load_op2:    in  std_logic;
		X1, Y1, Z1:            in  std_logic_vector(n-1 downto 0);
		X2, Y2, Z2:	       in  std_logic_vector(n-1 downto 0);
            	dout0, dout1:          out std_logic_vector(n-1 downto 0);
            	X3, Y3, Z3:            out std_logic_vector(n-1 downto 0)
            );
   end component;
   
   component MMALU
        port (rst  :     in  std_logic;
              clk  :     in  std_logic;
              load :     in  std_logic;
              x    :     in  std_logic_vector (n-1 downto 0);
              y    :     in  std_logic_vector (n-1 downto 0);
              t    :     out std_logic_vector (n-1 downto 0);
	      done :     out std_logic;
              en   :     in  std_logic;
              cmd  :     in  std_logic;
	      sub  :     in  std_logic);
    end component;
    
    -- Definition of signals
    -- Instuction:
    signal lo_addr, ro_addr:          std_logic_vector(2 downto 0);
    signal waddr: 	              std_logic_vector(2 downto 0);
    signal opcode: 		      std_logic_vector(1 downto 0);
    ----------------------------------------------------------
    signal lo_out, ro_out:            std_logic_vector(n-1 downto 0);
    signal MMALU_out:                 std_logic_vector(n-1 downto 0);
    signal load_operands, MMALU_done: std_logic;
    signal cmd, sub:	              std_logic;
    signal start_fsm:		      std_logic;
begin
   start_fsm <= en and load_op1 and load_op2;

   inst_MMALU : MMALU
    port map (rst  => rst,
              clk  => clk,
              load => load_operands,
              x    => lo_out,
              y    => ro_out,
              t    => MMALU_out,
	      done => MMALU_done,
              en   => en,
              cmd  => cmd, 
	      sub  => sub);

   inst_regfile: regfile
      port map(din        => MMALU_out,
      	       waddr      => waddr, 
      	       raddr0     => ro_addr, 
      	       raddr1     => lo_addr, 
      	       rst        => rst,
      	       clk        => clk, 
      	       we         => MMALU_done,
      	       load_op1   => load_op1,
      	       load_op2   => load_op2,
      	       X1         => X1,
      	       Y1	  => Y1,
      	       Z1	  => Z1,
      	       X2 	  => X2,
      	       Y2	  => Y2,
	       Z2	  => Z2,
      	       dout0      => ro_out, 
      	       dout1      => lo_out, 
      	       X3         => X3,
      	       Y3         => Y3,
      	       Z3         => Z3);

   inst_FSM: FSM
      port map(reset      => rst,
	       clock      => clk,
	       ce         => start_fsm, --This is an enable pulse and needs to be configured properly
	       MMALU_done => MMALU_done,
	       opcode     => opcode,
	       Asel       => lo_addr,
	       Bsel       => ro_addr,
	       Csel       => waddr,
               load_MMALU => load_operands,
	       done       => done
	       );
               
   inst_controller: controller
      port map(opcode => opcode,
               cmd    => cmd,
               sub    => sub);

end arch_point_addition;
