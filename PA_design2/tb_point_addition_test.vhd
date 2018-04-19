library ieee;
use ieee.std_logic_1164.all;

library work;
use work.constants.all;

entity tb_point_addition is
end tb_point_addition;

architecture tb of tb_point_addition is
    component point_addition
        generic(n: integer := log2primeM + 2);
   	port(  rst, clk:   in  std_logic;
               load_op1:   in  std_logic;
               load_op2:   in  std_logic;
               en:	   in  std_logic;
	       X1, Y1, Z1: in  std_logic_vector(n-1 downto 0);
	       X2, Y2, Z2: in  std_logic_vector(n-1 downto 0);
       	       done:	   out std_logic;
	       X3, Y3, Z3: out std_logic_vector(n-1 downto 0));
    end component;

    signal rst      : std_logic;
    signal clk      : std_logic := '0';
    signal load     : std_logic;
    signal en       : std_logic;
    signal X1       : std_logic_vector (log2primeM+1 downto 0);
    signal Y1       : std_logic_vector (log2primeM+1 downto 0);
    signal Z1       : std_logic_vector (log2primeM+1 downto 0);
    signal X2       : std_logic_vector (log2primeM+1 downto 0);
    signal Y2       : std_logic_vector (log2primeM+1 downto 0);
    signal Z2       : std_logic_vector (log2primeM+1 downto 0);
    signal done     : std_logic;
    signal X3       : std_logic_vector (log2primeM+1 downto 0);
    signal Y3       : std_logic_vector (log2primeM+1 downto 0);
    signal Z3       : std_logic_vector (log2primeM+1 downto 0);

    constant clk_period : time := 1000 us; -- EDIT Put right period here
    signal TbSimEnded : std_logic := '0';

begin

    dut : point_addition
    port map (rst  => rst, 
              clk  => clk,
              load_op1 => load,
              load_op2 => load,
              en   => en,
	      X1   => X1,
	      Y1   => Y1, 
	      Z1   => Z1,
	      X2   => X2, 
	      Y2   => Y2,
	      Z2   => Z2,
       	      done => done,
	      X3   => X3,
	      Y3   => Y3, 
	      Z3   => Z3);

    -- Clock generation
    clk <= not clk after clk_period/2 when TbSimEnded /= '1' else '0';

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        rst <= '0';
        load <= '0';

	en <= '1';
        
	-- General test
	-- Testing with the 3 bit prime 7 --> "111"
	-- Therefore we have a 5 bit datapath
	
	--> b = 2 therefore, 3*b = 6 (needs to be adjusted in constants.vhd
	
	-- Generating test data with magma:
	--> (x1:y1:z1)+(x2:y2:z2)=(x3:y3:z3)
        --> (0:4:1)+(5:6:1)=(3:6:1)
	--> R = 128 mod 7 = 2

	--> Conversion to Montgomery is unnecessary when using proj. coord.	
 
	X1 <= "00" & x"ed87544092aa9b6b91feaa88d6ed6133f769d024b0de9e9524511f3c37353ba6";
	Y1 <= "00" & x"6d49d8634120914da108f93ef4dda91f907575897954f8fdf5efeaea52070011";
	Z1 <= "00" & x"df10bda95599bb6c1d10cab9ae017bfab0af8344545c0d21ab52ecf7f27e2ccf";

	X2 <= "00" & x"ed87544092aa9b6b91feaa88d6ed6133f769d024b0de9e9524511f3c37353ba6";
	Y2 <= "00" & x"6d49d8634120914da108f93ef4dda91f907575897954f8fdf5efeaea52070011";
	Z2 <= "00" & x"df10bda95599bb6c1d10cab9ae017bfab0af8344545c0d21ab52ecf7f27e2ccf";

        wait for 10 * clk_period;
        
        -- Starting test process
        	rst <= '1';
		load <= '1';
		wait for clk_period;
		load <= '0';
		wait for clk_period*10;
		en <= '1';
		
        -- Wait until test is finished

	wait on done;
	wait for clk_period*2;
	en <= '0';
	
	-- End of simulation

    end process;

end tb;
